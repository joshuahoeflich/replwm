const fs = require("fs");
const path = require("path");

const PROJECT_ROOT = path.resolve(path.join(__dirname, ".."));

const toReplwmDir = (relPath) =>
  path.join(PROJECT_ROOT, "common-lisp", "replwm", relPath);

const toDirPath = (absPath) =>
  fs.readdirSync(absPath).map((el) => path.join(absPath, el));

const log = (el) => console.log(el);

["src", "test"].map(toReplwmDir).flatMap(toDirPath).forEach(log);
