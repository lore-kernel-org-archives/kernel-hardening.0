Return-Path: <SRS0=xBlj=EY=lists.openwall.com=kernel-hardening-return-20413-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E79EC56201
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:09:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CF21B2054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:09:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YwmN4Oeg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF21B2054F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20413-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3624 invoked by uid 550); 18 Nov 2020 22:08:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3526 invoked from network); 18 Nov 2020 22:08:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=x2TD2o4pBSR17VC4+EL/LXT5qmVrZ48B2unbu9dDZv4=;
        b=YwmN4Oeg1UAMMAvDf/aYZQSp7PRQBDhY4DcX1F/Zaj2s//K3l3zhNHgnYBk9U3oYu+
         NHzU0mXYptS+s3/9U5dDUN3Co6d6POTo8RKNt3BfPOsVUNdLyT04HV/pZMpZrfOngyTo
         odjy0dxn4EqqTly0ep+4LA8Vd2ZbT8bm1wfefNymdRLp1zUqTY8r9rrZW7nhevkwwNjy
         Qc5uwDF3ngA2LDo3oXWCJM+uy9N2hQCx7qG38aheG/zKIc4WrIaqwaUNdavvIYFzA8gl
         6cUeaZ3xNJgtSVLbpGLXTzIyLYoCQcHkLp3wIqlL2WCOaxdHyL2AHWnknfC9cpESBU1u
         YL9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x2TD2o4pBSR17VC4+EL/LXT5qmVrZ48B2unbu9dDZv4=;
        b=dXmhTpmen6Z8OkmCALGWpaUxtrFbPQKWhUjD6TN18fR+Sg3CELuFeivCVcTgMwjjzC
         98zibiQcLl0nxTKeWGnWuUWnZbI4ZhfLJl796i1yY2h/nJLE7BUi6c2ID1+xMCyTI85B
         uHZgK8Q5JQ7ivGj7+rcVejV+UoFpZh1CdcSUzOS3mwx9Q4pwHgmJjEYvW8fSHNDiWLQj
         7YrPVrcRXis9nJavf47qWMq2H67Fp/1nPNyOo0wdx6Xdz+zU9/voIjZXosS14BAzD9Rb
         KB/f136XhvmxLBvu+ZVY8kbj9NDJEMAhUNGOtpQpJ30ys8R/MP7YUTCrllf1CZLLX9l4
         gGuw==
X-Gm-Message-State: AOAM530fLnHDTGrv0JfqR9yOcLASBvKzCx+W0MsiqnE07o7t9rufPWrN
	m/FPFRii89HYWMg7CoIAaDLpuV3zN4RYAj4fbPo=
X-Google-Smtp-Source: ABdhPJzS6zX0XS9ZEH0MsX4Tij4regIQp/qE61D0OqeGgajmYiuu9FX6QEL9eVlk9mMI2ee2ECtuWGdsFegCGl2z2Hw=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5762:: with SMTP id
 r2mr7091445qvx.45.1605737267967; Wed, 18 Nov 2020 14:07:47 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:21 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 07/17] init: lto: ensure initcall ordering
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, the compiler doesn't necessarily obey the link order for
initcalls, and initcall variables need globally unique names to avoid
collisions at link time.

This change exports __KBUILD_MODNAME and adds the initcall_id() macro,
which uses it together with __COUNTER__ and __LINE__ to help ensure
these variables have unique names, and moves each variable to its own
section when LTO is enabled, so the correct order can be specified using
a linker script.

The generate_initcall_ordering.pl script uses nm to find initcalls from
the object files passed to the linker, and generates a linker script
that specifies the same order for initcalls that we would have without
LTO. With LTO enabled, the script is called in link-vmlinux.sh through
jobserver-exec to limit the number of jobs spawned.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 include/linux/init.h               |  52 +++++-
 scripts/Makefile.lib               |   6 +-
 scripts/generate_initcall_order.pl | 270 +++++++++++++++++++++++++++++
 scripts/link-vmlinux.sh            |  15 ++
 4 files changed, 334 insertions(+), 9 deletions(-)
 create mode 100755 scripts/generate_initcall_order.pl

diff --git a/include/linux/init.h b/include/linux/init.h
index 7b53cb3092ee..d466bea7ecba 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -184,19 +184,57 @@ extern bool initcall_debug;
  * as KEEP() in the linker script.
  */
 
+/* Format: <modname>__<counter>_<line>_<fn> */
+#define __initcall_id(fn)					\
+	__PASTE(__KBUILD_MODNAME,				\
+	__PASTE(__,						\
+	__PASTE(__COUNTER__,					\
+	__PASTE(_,						\
+	__PASTE(__LINE__,					\
+	__PASTE(_, fn))))))
+
+/* Format: __<prefix>__<iid><id> */
+#define __initcall_name(prefix, __iid, id)			\
+	__PASTE(__,						\
+	__PASTE(prefix,						\
+	__PASTE(__,						\
+	__PASTE(__iid, id))))
+
+#ifdef CONFIG_LTO_CLANG
+/*
+ * With LTO, the compiler doesn't necessarily obey link order for
+ * initcalls. In order to preserve the correct order, we add each
+ * variable into its own section and generate a linker script (in
+ * scripts/link-vmlinux.sh) to specify the order of the sections.
+ */
+#define __initcall_section(__sec, __iid)			\
+	#__sec ".init.." #__iid
+#else
+#define __initcall_section(__sec, __iid)			\
+	#__sec ".init"
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
-#define ___define_initcall(fn, id, __sec)			\
+#define ____define_initcall(fn, __name, __sec)			\
 	__ADDRESSABLE(fn)					\
-	asm(".section	\"" #__sec ".init\", \"a\"	\n"	\
-	"__initcall_" #fn #id ":			\n"	\
+	asm(".section	\"" __sec "\", \"a\"		\n"	\
+	    __stringify(__name) ":			\n"	\
 	    ".long	" #fn " - .			\n"	\
 	    ".previous					\n");
 #else
-#define ___define_initcall(fn, id, __sec) \
-	static initcall_t __initcall_##fn##id __used \
-		__attribute__((__section__(#__sec ".init"))) = fn;
+#define ____define_initcall(fn, __name, __sec)			\
+	static initcall_t __name __used 			\
+		__attribute__((__section__(__sec))) = fn;
 #endif
 
+#define __unique_initcall(fn, id, __sec, __iid)			\
+	____define_initcall(fn,					\
+		__initcall_name(initcall, __iid, id),		\
+		__initcall_section(__sec, __iid))
+
+#define ___define_initcall(fn, id, __sec)			\
+	__unique_initcall(fn, id, __sec, __initcall_id(fn))
+
 #define __define_initcall(fn, id) ___define_initcall(fn, id, .initcall##id)
 
 /*
@@ -236,7 +274,7 @@ extern bool initcall_debug;
 #define __exitcall(fn)						\
 	static exitcall_t __exitcall_##fn __exit_call = fn
 
-#define console_initcall(fn)	___define_initcall(fn,, .con_initcall)
+#define console_initcall(fn)	___define_initcall(fn, con, .con_initcall)
 
 struct obs_kernel_param {
 	const char *str;
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 94133708889d..53aa3e18ce8a 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -117,9 +117,11 @@ target-stem = $(basename $(patsubst $(obj)/%,%,$@))
 # These flags are needed for modversions and compiling, so we define them here
 # $(modname_flags) defines KBUILD_MODNAME as the name of the module it will
 # end up in (or would, if it gets compiled in)
-name-fix = $(call stringify,$(subst $(comma),_,$(subst -,_,$1)))
+name-fix-token = $(subst $(comma),_,$(subst -,_,$1))
+name-fix = $(call stringify,$(call name-fix-token,$1))
 basename_flags = -DKBUILD_BASENAME=$(call name-fix,$(basetarget))
-modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname))
+modname_flags  = -DKBUILD_MODNAME=$(call name-fix,$(modname)) \
+		 -D__KBUILD_MODNAME=kmod_$(call name-fix-token,$(modname))
 modfile_flags  = -DKBUILD_MODFILE=$(call stringify,$(modfile))
 
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(target-stem).o), \
diff --git a/scripts/generate_initcall_order.pl b/scripts/generate_initcall_order.pl
new file mode 100755
index 000000000000..1a88d3f1b913
--- /dev/null
+++ b/scripts/generate_initcall_order.pl
@@ -0,0 +1,270 @@
+#!/usr/bin/env perl
+# SPDX-License-Identifier: GPL-2.0
+#
+# Generates a linker script that specifies the correct initcall order.
+#
+# Copyright (C) 2019 Google LLC
+
+use strict;
+use warnings;
+use IO::Handle;
+use IO::Select;
+use POSIX ":sys_wait_h";
+
+my $nm = $ENV{'NM'} || die "$0: ERROR: NM not set?";
+my $objtree = $ENV{'objtree'} || '.';
+
+## currently active child processes
+my $jobs = {};		# child process pid -> file handle
+## results from child processes
+my $results = {};	# object index -> [ { level, secname }, ... ]
+
+## reads _NPROCESSORS_ONLN to determine the maximum number of processes to
+## start
+sub get_online_processors {
+	open(my $fh, "getconf _NPROCESSORS_ONLN 2>/dev/null |")
+		or die "$0: ERROR: failed to execute getconf: $!";
+	my $procs = <$fh>;
+	close($fh);
+
+	if (!($procs =~ /^\d+$/)) {
+		return 1;
+	}
+
+	return int($procs);
+}
+
+## writes results to the parent process
+## format: <file index> <initcall level> <base initcall section name>
+sub write_results {
+	my ($index, $initcalls) = @_;
+
+	# sort by the counter value to ensure the order of initcalls within
+	# each object file is correct
+	foreach my $counter (sort { $a <=> $b } keys(%{$initcalls})) {
+		my $level = $initcalls->{$counter}->{'level'};
+
+		# section name for the initcall function
+		my $secname = $initcalls->{$counter}->{'module'} . '__' .
+			      $counter . '_' .
+			      $initcalls->{$counter}->{'line'} . '_' .
+			      $initcalls->{$counter}->{'function'};
+
+		print "$index $level $secname\n";
+	}
+}
+
+## reads a result line from a child process and adds it to the $results array
+sub read_results{
+	my ($fh) = @_;
+
+	# each child prints out a full line w/ autoflush and exits after the
+	# last line, so even if buffered I/O blocks here, it shouldn't block
+	# very long
+	my $data = <$fh>;
+
+	if (!defined($data)) {
+		return 0;
+	}
+
+	chomp($data);
+
+	my ($index, $level, $secname) = $data =~
+		/^(\d+)\ ([^\ ]+)\ (.*)$/;
+
+	if (!defined($index) ||
+		!defined($level) ||
+		!defined($secname)) {
+		die "$0: ERROR: child process returned invalid data: $data\n";
+	}
+
+	$index = int($index);
+
+	if (!exists($results->{$index})) {
+		$results->{$index} = [];
+	}
+
+	push (@{$results->{$index}}, {
+		'level'   => $level,
+		'secname' => $secname
+	});
+
+	return 1;
+}
+
+## finds initcalls from an object file or all object files in an archive, and
+## writes results back to the parent process
+sub find_initcalls {
+	my ($index, $file) = @_;
+
+	die "$0: ERROR: file $file doesn't exist?" if (! -f $file);
+
+	open(my $fh, "\"$nm\" --defined-only \"$file\" 2>/dev/null |")
+		or die "$0: ERROR: failed to execute \"$nm\": $!";
+
+	my $initcalls = {};
+
+	while (<$fh>) {
+		chomp;
+
+		# check for the start of a new object file (if processing an
+		# archive)
+		my ($path)= $_ =~ /^(.+)\:$/;
+
+		if (defined($path)) {
+			write_results($index, $initcalls);
+			$initcalls = {};
+			next;
+		}
+
+		# look for an initcall
+		my ($module, $counter, $line, $symbol) = $_ =~
+			/[a-z]\s+__initcall__(\S*)__(\d+)_(\d+)_(.*)$/;
+
+		if (!defined($module)) {
+			$module = ''
+		}
+
+		if (!defined($counter) ||
+			!defined($line) ||
+			!defined($symbol)) {
+			next;
+		}
+
+		# parse initcall level
+		my ($function, $level) = $symbol =~
+			/^(.*)((early|rootfs|con|[0-9])s?)$/;
+
+		die "$0: ERROR: invalid initcall name $symbol in $file($path)"
+			if (!defined($function) || !defined($level));
+
+		$initcalls->{$counter} = {
+			'module'   => $module,
+			'line'     => $line,
+			'function' => $function,
+			'level'    => $level,
+		};
+	}
+
+	close($fh);
+	write_results($index, $initcalls);
+}
+
+## waits for any child process to complete, reads the results, and adds them to
+## the $results array for later processing
+sub wait_for_results {
+	my ($select) = @_;
+
+	my $pid = 0;
+	do {
+		# unblock children that may have a full write buffer
+		foreach my $fh ($select->can_read(0)) {
+			read_results($fh);
+		}
+
+		# check for children that have exited, read the remaining data
+		# from them, and clean up
+		$pid = waitpid(-1, WNOHANG);
+		if ($pid > 0) {
+			if (!exists($jobs->{$pid})) {
+				next;
+			}
+
+			my $fh = $jobs->{$pid};
+			$select->remove($fh);
+
+			while (read_results($fh)) {
+				# until eof
+			}
+
+			close($fh);
+			delete($jobs->{$pid});
+		}
+	} while ($pid > 0);
+}
+
+## forks a child to process each file passed in the command line and collects
+## the results
+sub process_files {
+	my $index = 0;
+	my $njobs = $ENV{'PARALLELISM'} || get_online_processors();
+	my $select = IO::Select->new();
+
+	while (my $file = shift(@ARGV)) {
+		# fork a child process and read it's stdout
+		my $pid = open(my $fh, '-|');
+
+		if (!defined($pid)) {
+			die "$0: ERROR: failed to fork: $!";
+		} elsif ($pid) {
+			# save the child process pid and the file handle
+			$select->add($fh);
+			$jobs->{$pid} = $fh;
+		} else {
+			# in the child process
+			STDOUT->autoflush(1);
+			find_initcalls($index, "$objtree/$file");
+			exit;
+		}
+
+		$index++;
+
+		# limit the number of children to $njobs
+		if (scalar(keys(%{$jobs})) >= $njobs) {
+			wait_for_results($select);
+		}
+	}
+
+	# wait for the remaining children to complete
+	while (scalar(keys(%{$jobs})) > 0) {
+		wait_for_results($select);
+	}
+}
+
+sub generate_initcall_lds() {
+	process_files();
+
+	my $sections = {};	# level -> [ secname, ...]
+
+	# sort results to retain link order and split to sections per
+	# initcall level
+	foreach my $index (sort { $a <=> $b } keys(%{$results})) {
+		foreach my $result (@{$results->{$index}}) {
+			my $level = $result->{'level'};
+
+			if (!exists($sections->{$level})) {
+				$sections->{$level} = [];
+			}
+
+			push(@{$sections->{$level}}, $result->{'secname'});
+		}
+	}
+
+	die "$0: ERROR: no initcalls?" if (!keys(%{$sections}));
+
+	# print out a linker script that defines the order of initcalls for
+	# each level
+	print "SECTIONS {\n";
+
+	foreach my $level (sort(keys(%{$sections}))) {
+		my $section;
+
+		if ($level eq 'con') {
+			$section = '.con_initcall.init';
+		} else {
+			$section = ".initcall${level}.init";
+		}
+
+		print "\t${section} : {\n";
+
+		foreach my $secname (@{$sections->{$level}}) {
+			print "\t\t*(${section}..${secname}) ;\n";
+		}
+
+		print "\t}\n";
+	}
+
+	print "}\n";
+}
+
+generate_initcall_lds();
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 78e55fe7210b..c5919d5a0b4f 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -43,6 +43,17 @@ info()
 	fi
 }
 
+# Generate a linker script to ensure correct ordering of initcalls.
+gen_initcalls()
+{
+	info GEN .tmp_initcalls.lds
+
+	${PYTHON} ${srctree}/scripts/jobserver-exec		\
+	${PERL} ${srctree}/scripts/generate_initcall_order.pl	\
+		${KBUILD_VMLINUX_OBJS} ${KBUILD_VMLINUX_LIBS}	\
+		> .tmp_initcalls.lds
+}
+
 # If CONFIG_LTO_CLANG is selected, collect generated symbol versions into
 # .tmp_symversions.lds
 gen_symversions()
@@ -72,6 +83,9 @@ modpost_link()
 		--end-group"
 
 	if [ -n "${CONFIG_LTO_CLANG}" ]; then
+		gen_initcalls
+		lds="-T .tmp_initcalls.lds"
+
 		if [ -n "${CONFIG_MODVERSIONS}" ]; then
 			gen_symversions
 			lds="${lds} -T .tmp_symversions.lds"
@@ -262,6 +276,7 @@ cleanup()
 {
 	rm -f .btf.*
 	rm -f .tmp_System.map
+	rm -f .tmp_initcalls.lds
 	rm -f .tmp_symversions.lds
 	rm -f .tmp_vmlinux*
 	rm -f System.map
-- 
2.29.2.299.gdc1121823c-goog

