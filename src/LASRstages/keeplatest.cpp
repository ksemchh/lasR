#include "keeplatest.h"
#include "Grid.h"

#include <limits>
#include <vector>

bool LASRkeeplatest::set_parameters(const nlohmann::json& stage)
{
  res = stage.at("res");
  window = stage.value("window", 3600.0);
  attribute = stage.value("use_attribute", "gpstime");

  if (res <= 0)
  {
    last_error = "the resolution must be strictly positive";
    return false;
  }

  return true;
}

bool LASRkeeplatest::process(PointCloud*& las)
{
  AttributeAccessor accessor(attribute);

  Grid grid(las->header->min_x, las->header->min_y, las->header->max_x, las->header->max_y, res);
  std::vector<double> latest(grid.get_ncells(), std::numeric_limits<double>::lowest());

  while (las->read_point())
  {
    if (pointfilter.filter(&las->point)) continue;

    int cell = grid.cell_from_xy(las->point.get_x(), las->point.get_y());
    double t = accessor(&las->point);
    if (t > latest[cell]) latest[cell] = t;
  }

  // A cell reached by a single acquisition has its own time as the latest, so nothing there
  // is dropped: an older survey survives where it is the only cover
  while (las->read_point())
  {
    if (pointfilter.filter(&las->point)) continue;

    int cell = grid.cell_from_xy(las->point.get_x(), las->point.get_y());
    if (accessor(&las->point) <= latest[cell] - window) las->point.set_deleted();
  }

  las->update_header();
  las->delete_deleted();

  return true;
}
