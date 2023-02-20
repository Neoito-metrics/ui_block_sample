#!/bin/bash

CLEAR="\e[0m"
GREEN="\e[32m"
MAGENTA_BG_BOLD="\e[1;45m"
GREEN_BG_BOLD="\e[1;42m"
RED_BG_BOLD="\e[1;41m"
BLUE_BG_BOLD="\e[1;44m"

function handler() {
    echo -e "${RED_BG_BOLD}Error: Installation failed on the way. Please try again.${CLEAR}"
    exit 1
}
trap handler ERR

echo "Installing linting and related packages"
echo -e "------------------------------------\n\n"

echo -e "Installing ${MAGENTA_BG_BOLD}Commitlint${CLEAR}"
npm i --save-dev commitlint @commitlint/cli @commitlint/config-conventional
echo "module.exports = {extends: ['@commitlint/config-conventional']}" >>commitlint.config.cjs
echo -e "Successfully installed ${BLUE_BG_BOLD}Commitlint${CLEAR}"

echo -e "Installing ${MAGENTA_BG_BOLD}Eslint${CLEAR}"
npm i --save-dev eslint eslint-config-standard eslint-plugin-import eslint-plugin-n eslint-plugin-promise eslint-plugin-react
echo "/dist
.next
next-env.d.ts
node_modules
next.config.js
yarn.lock
package-lock.json
public
out" >>.eslintignore
echo "{
  \"env\": {
    \"browser\": true,
    \"es2021\": true
  },
  \"extends\": [\"plugin:react/recommended\", \"standard\", \"eslint:recommended\"],
  \"overrides\": [],
  \"parserOptions\": {
    \"ecmaVersion\": \"latest\",
    \"sourceType\": \"module\"
  },
  \"plugins\": [\"react\"],
  \"rules\": {
    \"camelcase\": \"warn\",
    \"default-case\": \"error\",
    \"no-octal\": \"error\",
    \"no-var\": \"error\",
    \"eol-last\": \"error\",
    \"semi\": \"error\",
    \"complexity\": [\"ewarn\", 10],
    \"curly\": \"error\",
    \"jsx-quotes\": [\"error\", \"prefer-double\"],
    \"no-redeclare\": [2, { \"builtinGlobals\": true }]
  }
}
" >>.eslintrc.json
echo -e "Successfully installed ${BLUE_BG_BOLD}Eslint${CLEAR}"

echo -e "Installing ${MAGENTA_BG_BOLD}Lintstaged${CLEAR}"
npm install --save-dev lint-staged
echo "{
  \"**/*.+(js|ts|tsx)\": [
    \"eslint --ext ts --ext tsx --ext js\"
  ],
  \"**/*.{js,jsx,ts,tsx,json,css,scss,md}\": [
    \"prettier  --write\"
  ]
}
" >>.lintstagedrc.json
echo -e "Successfully installed ${BLUE_BG_BOLD}Lintstaged${CLEAR}"

echo -e "Installing ${MAGENTA_BG_BOLD}Husky${CLEAR}"
npm install husky --save-dev && npx husky install && npm pkg set scripts.prepare="husky install"
npx husky add .husky/commit-msg 'npx commitlint --edit'
npx husky add .husky/pre-commit ''
echo "{
  \"hooks\": {
    \"pre-commit\": \"lint-staged\"
  }
}
" >>.huskyrc
echo "#!/usr/bin/env sh
. \"\$(dirname -- \"\$0\")/_/husky.sh\"

npx commitlint --edit
" >>./.husky/commit-msg
echo -e "Successfully installed ${BLUE_BG_BOLD}Husky${CLEAR}"

echo -e "Installing ${MAGENTA_BG_BOLD}Prettier${CLEAR}"
npm install --save-dev --save-exact prettier
echo "{
    \"printWidth\": 100,
    \"tabWidth\": 2,
    \"singleQuote\": false,
    \"trailingComma\": \"all\",
    \"semi\": true,
    \"arrowParens\": \"avoid\"
}" >>.prettierrc
echo -e "Successfully installed ${BLUE_BG_BOLD}Prettier${CLEAR}"

echo -e "Installed ${GREEN}Commitlint${CLEAR}, ${GREEN}Eslint${CLEAR}, ${GREEN}Lintstaged${CLEAR}, ${GREEN}Husky${CLEAR} and ${GREEN}Prettier${CLEAR}"
