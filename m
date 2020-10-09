Return-Path: <SRS0=XjjI=DQ=lists.openwall.com=kernel-hardening-return-20142-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE8DC433E7
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:16:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 58BFB2225D
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MSqEBLKM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58BFB2225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20142-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4089 invoked by uid 550); 9 Oct 2020 16:14:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3977 invoked from network); 9 Oct 2020 16:14:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=xnUso1aX/PbHivFqRBQYlx5NFQiCnga6+/KbuoETb6w=;
        b=MSqEBLKMdPi79OQ4IpYM9tZpSmQq9rCR2zCScxB9Jg+Rjn5TE2hQe3jeVcKWPZRRzU
         X+hyGEZdpMH+H5SvjVVr8N2lVagNWFmRbRs5whUh8iYtdhOP3dybs0DPuNXwRAKG/9kV
         r2eZ+/3Fn0+5lI5RUWCsXI9p/4R2iyNaPuz+J0AnU3Pnh/cx8nWk1Fqjhrgyk6GPWovW
         pvoYY3rWNtKxOxntgtWPwuAVk+uDdzUzZrtLbmbGCJxz8XWhNZI/9m3btgYnbB6aHyTx
         XEhII0cZjQMctUm6RTYwIRXmQ36CIspOzDVhiIvAQxi11QKehL7Ti/qalBFjyZYVR6Tg
         dUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xnUso1aX/PbHivFqRBQYlx5NFQiCnga6+/KbuoETb6w=;
        b=aH1eNkhAJuzF3VxbvOnHQiHPQmYyBWm78lvZxHJKdjh4SKaG3QXNKCTvgzSdp3eDBk
         aKpsQzMR8zeHXgTJpLfbhKjZe5vhhHq+lwWXl5UDNLbYVo3i4ATfv5UWqvAKeDkJt+zm
         PMTs7KHBb1V5VSM0PS8zVbGmFpyr8xobR/rrdT2MWwvhVPs/ar5GH9R4RBkKHKvRG73x
         6t9FPoYVker8HgIOGWyiiB7Mi/yzZpoZ2sb8mpgwjieYze1aEQlkob6cJtmqXOoXNGhd
         2W+gb+4e5/paGA90v6487c2OtiIs0WD16du8TVc5ot4ITH0tDpbAbfeWcnZZPraHzDwO
         39CQ==
X-Gm-Message-State: AOAM530MGLPe3ojOebD5NB5pcdxjhffVL8a88e0ZR3Dqul/ps/uvXqcV
	r8qWdURgw1S/xeQU2BLXY3JtzvRIv0oFCiu3YlQ=
X-Google-Smtp-Source: ABdhPJxoUvjPd0KirKqVgXTGqcuP6VOxl5n3zsB3Oqj62mI3JXDh0hff+O/0T6aW7bn8lhU/kRKH8PR/V7M+1aePunM=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a63:8f5d:: with SMTP id
 r29mr3885294pgn.18.1602260043266; Fri, 09 Oct 2020 09:14:03 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:20 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 11/29] kbuild: lto: postpone objtool
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, LLVM bitcode won't be compiled into native code until
modpost_link, or modfinal for modules. This change postpones calls
to objtool until after these steps, and moves objtool_args to
Makefile.lib, so the arguments can be reused in Makefile.modfinal.

As we didn't have objects to process earlier, we use --duplicate
when processing vmlinux.o. This change also disables unreachable
instruction warnings with LTO to avoid warnings about the int3
padding between functions.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig              |  2 +-
 scripts/Makefile.build    | 19 ++-----------------
 scripts/Makefile.lib      | 11 +++++++++++
 scripts/Makefile.modfinal | 19 ++++++++++++++++---
 scripts/link-vmlinux.sh   | 28 +++++++++++++++++++++++++---
 5 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index caeb6feb517e..74cbd6e3b116 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -612,7 +612,7 @@ config LTO_CLANG
 	depends on $(success,$(NM) --help | head -n 1 | grep -qi llvm)
 	depends on $(success,$(AR) --help | head -n 1 | grep -qi llvm)
 	depends on ARCH_SUPPORTS_LTO_CLANG
-	depends on !FTRACE_MCOUNT_RECORD
+	depends on !FTRACE_MCOUNT_USE_RECORDMCOUNT
 	depends on !KASAN
 	depends on !GCOV_KERNEL
 	select LTO
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index eae2f5386a03..ab0ddf4884fd 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -218,27 +218,11 @@ cmd_record_mcount = $(if $(findstring $(strip $(CC_FLAGS_FTRACE)),$(_c_flags)),
 endif # CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 
 ifdef CONFIG_STACK_VALIDATION
+ifndef CONFIG_LTO_CLANG
 ifneq ($(SKIP_STACK_VALIDATION),1)
 
 __objtool_obj := $(objtree)/tools/objtool/objtool
 
-objtool_args = $(if $(CONFIG_UNWINDER_ORC),orc generate,check)
-
-objtool_args += $(if $(part-of-module), --module,)
-
-ifndef CONFIG_FRAME_POINTER
-objtool_args += --no-fp
-endif
-ifdef CONFIG_GCOV_KERNEL
-objtool_args += --no-unreachable
-endif
-ifdef CONFIG_RETPOLINE
-  objtool_args += --retpoline
-endif
-ifdef CONFIG_X86_SMAP
-  objtool_args += --uaccess
-endif
-
 # 'OBJECT_FILES_NON_STANDARD := y': skip objtool checking for a directory
 # 'OBJECT_FILES_NON_STANDARD_foo.o := 'y': skip objtool checking for a file
 # 'OBJECT_FILES_NON_STANDARD_foo.o := 'n': override directory skip for a file
@@ -250,6 +234,7 @@ objtool_obj = $(if $(patsubst y%,, \
 	$(__objtool_obj))
 
 endif # SKIP_STACK_VALIDATION
+endif # CONFIG_LTO_CLANG
 endif # CONFIG_STACK_VALIDATION
 
 # Rebuild all objects when objtool changes, or is enabled/disabled.
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 3d599716940c..ecb97c9f5feb 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -216,6 +216,17 @@ dtc_cpp_flags  = -Wp,-MMD,$(depfile).pre.tmp -nostdinc                    \
 		 $(addprefix -I,$(DTC_INCLUDE))                          \
 		 -undef -D__DTS__
 
+# Objtool arguments are also needed for modfinal with LTO, so we define
+# then here to avoid duplication.
+objtool_args =								\
+	$(if $(CONFIG_UNWINDER_ORC),orc generate,check)			\
+	$(if $(part-of-module), --module,)				\
+	$(if $(CONFIG_FRAME_POINTER),, --no-fp)				\
+	$(if $(CONFIG_GCOV_KERNEL), --no-unreachable,)			\
+	$(if $(CONFIG_RETPOLINE), --retpoline,)				\
+	$(if $(CONFIG_X86_SMAP), --uaccess,)				\
+	$(if $(CONFIG_FTRACE_MCOUNT_USE_OBJTOOL), --mcount,)
+
 # Useful for describing the dependency of composite objects
 # Usage:
 #   $(call multi_depend, multi_used_targets, suffix_to_remove, suffix_to_add)
diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
index 2cb9a1d88434..1bd2953b11c4 100644
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@ -9,7 +9,7 @@ __modfinal:
 include $(objtree)/include/config/auto.conf
 include $(srctree)/scripts/Kbuild.include
 
-# for c_flags
+# for c_flags and objtool_args
 include $(srctree)/scripts/Makefile.lib
 
 # find all modules listed in modules.order
@@ -34,10 +34,23 @@ ifdef CONFIG_LTO_CLANG
 # With CONFIG_LTO_CLANG, reuse the object file we compiled for modpost to
 # avoid a second slow LTO link
 prelink-ext := .lto
-endif
+
+# ELF processing was skipped earlier because we didn't have native code,
+# so let's now process the prelinked binary before we link the module.
+
+ifdef CONFIG_STACK_VALIDATION
+ifneq ($(SKIP_STACK_VALIDATION),1)
+cmd_ld_ko_o +=								\
+	$(objtree)/tools/objtool/objtool $(objtool_args)		\
+		$(@:.ko=$(prelink-ext).o);
+
+endif # SKIP_STACK_VALIDATION
+endif # CONFIG_STACK_VALIDATION
+
+endif # CONFIG_LTO_CLANG
 
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o =                                                     \
+      cmd_ld_ko_o +=							\
 	$(LD) -r $(KBUILD_LDFLAGS)					\
 		$(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)		\
 		-T scripts/module.lds -o $@ $(filter %.o, $^);		\
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 5ace1dc43993..7f4d19271180 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -89,14 +89,36 @@ modpost_link()
 
 objtool_link()
 {
+	local objtoolcmd;
 	local objtoolopt;
 
+	if [ "${CONFIG_LTO_CLANG} ${CONFIG_STACK_VALIDATION}" = "y y" ]; then
+		# Don't perform vmlinux validation unless explicitly requested,
+		# but run objtool on vmlinux.o now that we have an object file.
+		if [ -n "${CONFIG_UNWINDER_ORC}" ]; then
+			objtoolcmd="orc generate"
+		fi
+
+		objtoolopt="${objtoolopt} --duplicate"
+
+		if [ -n "${CONFIG_FTRACE_MCOUNT_USE_OBJTOOL}" ]; then
+			objtoolopt="${objtoolopt} --mcount"
+		fi
+	fi
+
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
-		objtoolopt="check --vmlinux --noinstr"
+		objtoolopt="${objtoolopt} --noinstr"
+	fi
+
+	if [ -n "${objtoolopt}" ]; then
+		if [ -z "${objtoolcmd}" ]; then
+			objtoolcmd="check"
+		fi
+		objtoolopt="${objtoolopt} --vmlinux"
 		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
 			objtoolopt="${objtoolopt} --no-fp"
 		fi
-		if [ -n "${CONFIG_GCOV_KERNEL}" ]; then
+		if [ -n "${CONFIG_GCOV_KERNEL}" ] || [ -n "${CONFIG_LTO_CLANG}" ]; then
 			objtoolopt="${objtoolopt} --no-unreachable"
 		fi
 		if [ -n "${CONFIG_RETPOLINE}" ]; then
@@ -106,7 +128,7 @@ objtool_link()
 			objtoolopt="${objtoolopt} --uaccess"
 		fi
 		info OBJTOOL ${1}
-		tools/objtool/objtool ${objtoolopt} ${1}
+		tools/objtool/objtool ${objtoolcmd} ${objtoolopt} ${1}
 	fi
 }
 
-- 
2.28.0.1011.ga647a8990f-goog

