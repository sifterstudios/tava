const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

// Determine the platform-specific command
const isWindows = os.platform() === 'win32';
const flutterCommand = isWindows ? 'flutter.bat' : 'flutter';
const dartCommand = isWindows ? 'dart.bat' : 'dart';

// Function to find Flutter in common installation locations
function findFlutterPath() {
  const commonPaths = [
    // Common Flutter SDK locations
    path.join(os.homedir(), 'flutter', 'bin'),
    path.join(os.homedir(), 'development', 'flutter', 'bin'),
    path.join(os.homedir(), 'dev', 'flutter', 'bin'),
    path.join('C:', 'flutter', 'bin'),
    path.join('C:', 'src', 'flutter', 'bin'),
    path.join('/usr', 'local', 'flutter', 'bin'),
    path.join('/opt', 'flutter', 'bin'),
    // Add more common paths as needed
  ];

  for (const p of commonPaths) {
    const flutterPath = path.join(p, flutterCommand);
    if (fs.existsSync(flutterPath)) {
      return p;
    }
  }

  return null;
}

// Get the command to run (flutter or dart)
const command = process.argv[2] === 'pub' ? dartCommand : flutterCommand;

// Get the arguments
const args = process.argv.slice(2);

// Try to find Flutter SDK
const flutterPath = findFlutterPath();

if (!flutterPath) {
  console.error('\x1b[31mError: Flutter SDK not found in common locations.\x1b[0m');
  console.error('Please make sure Flutter is installed and add it to your PATH, or update this script with your Flutter installation path.');
  process.exit(1);
}

// Construct the full path to the command
const commandPath = path.join(flutterPath, command);

console.log(`Running: ${commandPath} ${args.join(' ')}`);

// Spawn the process
const child = spawn(commandPath, args, {
  stdio: 'inherit',
  shell: true
});

// Handle process exit
child.on('close', (code) => {
  if (code !== 0) {
    console.error(`\x1b[31mCommand failed with exit code ${code}\x1b[0m`);
  }
  process.exit(code);
});