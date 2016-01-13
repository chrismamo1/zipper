let () =
  let fname = ref "" in
  let oname = ref "" in
  let compress = ref true in
  let decompress = ref false in
  let small = ref false in
  let speclist = [
    "-file", Arg.Set_string fname, "name of input file";
    "-output", Arg.Set_string oname, "name of output file";
    "--compress", Arg.Set compress, "switch to compress file";
    "--decompress", Arg.Set decompress, "switch to decompress file";
    "--small", Arg.Set small, "switch to enable 'small' mode, which is slower but more memory efficient";
  ] in
  let () =
    Arg.parse
      speclist
      print_endline
      "This is a simple utility to exercise the capabilities of camlbz2." in
  let fname = !fname in
  let oname = if !oname = "" then fname ^ ".bz2" else !oname in
  let decompress = !decompress in
  let compress = if decompress then false else true in
  let small = !small in
  match compress, decompress with
  | true, false ->
      let ic = open_in fname in
      let oc = open_out oname in
      let oc' = Bz2.open_out oc in
      let buflen = 4096 in
      let buffer = Bytes.create buflen in
      let nread = ref buflen in
      while !nread >= buflen do
        nread := input ic buffer 0 buflen;
        Bz2.write oc' buffer 0 !nread;
      done;
      Bz2.close_out oc';
      close_in ic;
      close_out oc;
  | false, true ->
      let ic = open_in_bin fname in
      let oc = open_out oname in
      let ic' = Bz2.open_in ~small ic in
      let buflen = 4096 in
      let buffer = Bytes.create buflen in
      let nread = ref buflen in
      while !nread = buflen do
        nread := Bz2.read ic' buffer 0 buflen;
        output oc buffer 0 !nread;
      done;
      Bz2.close_in ic';
      close_in ic;
      close_out oc;
  | _, _ -> raise (Failure "What the fuck?")
