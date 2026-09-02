#ifndef CSF_H
#define CSF_H

#include "Stage.h"

// A particle holds a mass, three vectors of three doubles, two positions in the grid, its
// neighbours and the bookkeeping of the simulation
#define CSF_PARTICLE_BYTES 224

class LASRcsf: public Stage
{
public:
  LASRcsf();
  bool process(PointCloud*& las) override;
  double need_buffer() const override { return cloth_resolution*5; };

  // Three copies of the coordinates coexist: the ones read here, the vector setPointCloud takes by
  // value and the one it keeps. The classification adds an index per point, and the cloth an index
  // per point in the particle it lands on.
  double memory_per_point() const override { return 3*3*sizeof(double) + 2*sizeof(int); };

  // A particle of the cloth, its neighbours and its height, on a grid of the cloth resolution
  double memory_per_area() const override { return cloth_resolution > 0 ? (CSF_PARTICLE_BYTES + sizeof(double))/(cloth_resolution*cloth_resolution) : 0; };
  bool is_parallelized() const override { return true; };
  bool set_parameters(const nlohmann::json&) override;
  std::string get_name() const override { return "csf"; };

  // multi-threading
  LASRcsf* clone() const override { return new LASRcsf(*this); };

private:
  bool slope_smooth;
  float class_threshold;
  float cloth_resolution;
  int  rigidness;
  int iterations;
  float time_step;
  int classification;
};

#endif