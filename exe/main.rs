use subprocess::{Exec, Redirection};
use std::process::Command;

fn main() {
    let mut cmd = Command::new("docker");
    cmd.arg("rm").arg("skat_proxy");
    cmd.output();

    let docker_command = format!(
        "docker run -v .\\vars.config:/mnt/vars.config --name skat_proxy --privileged -p 8888:8080 -it ncbrj/skat-vpn-proxy"
    );

    let mut cmd = Exec::shell(docker_command)
        .stdout(Redirection::Pipe)
        .stderr(Redirection::Pipe)
        .popen()
        .expect("Failed to start Docker command");

    let stdout_handle = cmd.stdout.take().expect("Failed to open stdout");
    let stderr_handle = cmd.stderr.take().expect("Failed to open stderr");


    std::thread::spawn(move || {
        std::io::copy(&mut std::io::BufReader::new(stdout_handle), &mut std::io::stdout()).unwrap();
    });

    std::thread::spawn(move || {
        std::io::copy(&mut std::io::BufReader::new(stderr_handle), &mut std::io::stderr()).unwrap();
    });

}