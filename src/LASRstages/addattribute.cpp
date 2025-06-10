#include "addattribute.h"

LASRaddattribute::LASRaddattribute()
{
}

bool LASRaddattribute::process(PointCloud*& las)
{
  Attribute attr(name, data_type, scale, offset, description);
  return las->add_attribute(attr);
}

bool LASRaddattribute::set_parameters(const nlohmann::json& stage)
{
  std::string type = stage.at("data_type");
  name = stage.at("name");
  description = stage.at("description");
  scale = stage.value("scale", 1.0);
  offset = stage.value("offset", 0.0);
  data_type = AttributeType::NOTYPE;

  if (type == "uchar")       data_type = AttributeType::UINT8;
  else if (type == "char")   data_type = AttributeType::INT8;
  else if (type == "ushort") data_type = AttributeType::UINT16;
  else if (type == "short")  data_type = AttributeType::INT16;
  else if (type == "uint")   data_type = AttributeType::UINT32;
  else if (type == "int")    data_type = AttributeType::INT32;
  else if (type == "uint64") data_type = AttributeType::UINT64;
  else if (type == "int64")  data_type = AttributeType::INT64;
  else if (type == "float")  data_type = AttributeType::FLOAT;
  else if (type == "double") data_type = AttributeType::DOUBLE;

  return true;
}

LASRremoveattribute::LASRremoveattribute()
{
}

bool LASRremoveattribute::process(PointCloud*& las)
{
  return las->remove_attribute(name);
}

bool LASRremoveattribute::set_parameters(const nlohmann::json& stage)
{
  name = stage.at("name");
  if (name == "x" || name == "X" ||
      name == "y" || name == "Y" ||
      name == "z" || name == "Z")
  {
    last_error = "Removing point coordinates is not allowed";
    return false;
  }
  return true;
}