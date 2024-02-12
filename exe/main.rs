use std::process::Command;

fn main() {
    let mut cmd = Command::new("docker");
    cmd.arg("rm").arg("--force").arg("skat_proxy");
    let _ = cmd.output();

    let _ = Command::new("docker")
        .args(&[
            "run",
            "-v",
            ".\\vars.config:/mnt/vars.config",
            "--name",
            "skat_proxy",
            "--privileged",
            "-p",
            "8888:8080",
            "-it",
            "ncbrj/skat-vpn-proxy",
        ])
        .spawn()
        .expect("Failed to execute command")
        .wait();


}