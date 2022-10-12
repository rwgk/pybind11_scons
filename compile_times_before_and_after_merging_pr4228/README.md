```
git checkout master_before_cuda_fix2
git show > git_show_master_before_cuda_fix2.txt
git checkout master_after_cuda_fix2
git show > git_show_master_after_cuda_fix2.txt
```

Apply SConscript_patch.txt (to pybind11_scons/SConscript)

Ensure time_clang++ is on PATH

```
$ clang++ --version
Debian clang version 14.0.6-2
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin
```

Run many_time_clang++.sh (creates master_*.txt files)

```
     32K Oct 11 19:53 master_before_cuda_fix2_00.txt
     32K Oct 11 20:03 master_before_cuda_fix2_01.txt
     32K Oct 11 20:14 master_before_cuda_fix2_02.txt
     32K Oct 11 20:24 master_before_cuda_fix2_03.txt
     32K Oct 11 20:33 master_after_cuda_fix2_00.txt
     32K Oct 11 20:42 master_after_cuda_fix2_01.txt
     32K Oct 11 20:50 master_after_cuda_fix2_02.txt
     32K Oct 11 20:58 master_after_cuda_fix2_03.txt
```

```
python3 extract_times_to_csv.py master_before*.txt master_after*.txt
```

Copy-paste output to sheets

https://docs.google.com/spreadsheets/d/18Nir1-pfsr1OJVqQhBnff6IKU2EO6wgVs9qNk8s1Z7o/edit?usp=sharing
