Return-Path: <SRS0=EFR4=DG=lists.openwall.com=kernel-hardening-return-20043-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.9 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B49C4727D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B171F2076D
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 21:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kToejlLl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B171F2076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20043-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30274 invoked by uid 550); 29 Sep 2020 21:47:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30092 invoked from network); 29 Sep 2020 21:47:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2okmmeDec87SvOMXd3N63vsJjy9YUD5GxywHhacqWBg=;
        b=kToejlLlqGptIwLXcDPvbKglu754ifNvO9iTeVa3u+EV8TEpqjS73nHax81YvUaVZL
         T/0Q4fMfb9ggHmSmjSG3Kd4uZzzKmJCji6bWnEQpxwhEGsUdMQNLnFyGhSpogmfNeWLj
         mXiDsL/9X5jotDfGR/8RKZht7W+XvGDuVR6x/Fgsxtqr3gR4lg5vO8VC1Qb3rVK5GVR8
         CFKlK+vkMpQ8uPiNASCXWJVwMeX/K6ZJmQOsRyUlWa/8mQc5+1cBgztLEKwG//cD62xV
         NEuSlow7/hT8h7VvR9z9FrS/gRBZHlfsnQa+3PlMS29knEVZwoj+6EA6BsYR+gy46MtA
         nM3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2okmmeDec87SvOMXd3N63vsJjy9YUD5GxywHhacqWBg=;
        b=UF0IsvWgf5UQXkswlC98p6XJAaC20LjUC+PYLiShx5l7ov/XWethQPWNs2avzCfbNx
         bckTcz3riTCFuPMoXwbkUWRo33gFND9hBuBpL5b7W5tpBKcJ3h5lRRx79oTVGm7uh1FU
         9+aeoqSXxKO2tu6iCuPoYlW/e3hzyMDWdrMpqrA29l1g5KsI2YhQPOa1i+65hVscTFMs
         2n8dmGRUaVF/N99N35PtvDNhDC10Hiq080ds7VCOlTL1kWl0G3Cpma9xANNT5e4b5EHa
         1oDmG42lBiwWrp7SAxSXHluUonDwaJON5zlPy1kAtRhpErjkjlEANH0UWwODfTsY4Kh3
         0t1g==
X-Gm-Message-State: AOAM533pbn5SuUFJQU6gEr4QTOi58kVDI5G91UwHcVGItUwtdaLpKOxr
	roWuvTDGNW3fq0lXQPnhWusN1maVfvwcipiD6xs=
X-Google-Smtp-Source: ABdhPJynVs+sQdYs4vVxH7oG6PpXYs1z1lMMwLQnFwrGBcjgx1UBe9Pq7jcAJ1Hv1pz6pl+horyenbJ3EpwvFhmYqfI=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:a899:: with SMTP id
 x25mr6108251qva.46.1601416021752; Tue, 29 Sep 2020 14:47:01 -0700 (PDT)
Date: Tue, 29 Sep 2020 14:46:15 -0700
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
Message-Id: <20200929214631.3516445-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH v4 13/29] kbuild: lto: postpone objtool
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

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig              |  2 +-
 scripts/Makefile.build    | 19 ++-----------------
 scripts/Makefile.lib      | 11 +++++++++++
 scripts/Makefile.modfinal | 19 ++++++++++++++++---
 scripts/link-vmlinux.sh   | 23 ++++++++++++++++++++++-
 5 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 520e900efc75..db57ea19649b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -600,7 +600,7 @@ config LTO_CLANG
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
index 3e99a19b9195..96cf5a5d19df 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -93,8 +93,29 @@ objtool_link()
 {
 	local objtoolopt;
 
+	if [ "${CONFIG_LTO_CLANG} ${CONFIG_STACK_VALIDATION}" = "y y" ]; then
+		# Don't perform vmlinux validation unless explicitly requested,
+		# but run objtool on vmlinux.o now that we have an object file.
+		if [ -n "${CONFIG_UNWINDER_ORC}" ]; then
+			objtoolopt="orc generate"
+		else
+			objtoolopt="check"
+		fi
+
+		if [ -n ${CONFIG_FTRACE_MCOUNT_USE_OBJTOOL} ]; then
+			objtoolopt="${objtoolopt} --mcount"
+		fi
+	fi
+
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
-		objtoolopt="check --vmlinux"
+		if [ -z "${objtoolopt}" ]; then
+			objtoolopt="check --vmlinux"
+		else
+			objtoolopt="${objtoolopt} --vmlinux"
+		fi
+	fi
+
+	if [ -n "${objtoolopt}" ]; then
 		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
 			objtoolopt="${objtoolopt} --no-fp"
 		fi
-- 
2.28.0.709.gb0816b6eb0-goog

