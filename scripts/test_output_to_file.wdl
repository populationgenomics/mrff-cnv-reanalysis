#!
version development

workflow hello {
  input {
    String? inp = "Hello, world!"
  }

  call echo as print {
    input:
      inp = select_first([inp, "Hello, world!"])
  }
  output {
    String out = print.out
  }
}

task echo {
  input {
    String inp
    Boolean? include_newline
  }
  command <<<
    echo \
      ~{if (defined(include_newline) && select_first([include_newline])) then "-n" else ""} \
      '~{inp}' > hello_wdl.txt
  >>>
  runtime {
    cpu: 1
    disks: "local-disk 10 SSD"
    docker: "ubuntu@sha256:1d7b639619bdca2d008eca2d5293e3c43ff84cbee597ff76de3b7a7de3e84956"
    memory: "1G"
  }
  output {
    File out = "hello_wdl.txt"
  }
}
