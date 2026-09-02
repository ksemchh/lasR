#ifndef LASRSORT_H
#define LASRSORT_H

#include "Stage.h"
#include "Interval.h"

class LASRsort : public Stage
{
public:
  LASRsort() : spatial(false) { };
  bool process(PointCloud*& las) override;
  bool set_parameters(const nlohmann::json&) override;

  // A spatial sort groups the points in a grid, copies the groups into an ordered map, and builds
  // the order it sorts by: an interval per point in the grid and in its copy, an index per point,
  // and the visited bits of the permutation.
  double memory_per_point() const override { return spatial ? 2*sizeof(Interval) + sizeof(int) + 1 : 0; };
  std::string get_name() const override { return "sort"; };

  // multi-threading
  LASRsort* clone() const override { return new LASRsort(*this); };

private:
  bool spatial;
};

#endif