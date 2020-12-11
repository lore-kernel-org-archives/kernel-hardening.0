Return-Path: <SRS0=Yvfv=FP=lists.openwall.com=kernel-hardening-return-20585-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF815C4167B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:47:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C17F623F37
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:47:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C17F623F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20585-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5783 invoked by uid 550); 11 Dec 2020 18:46:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5670 invoked from network); 11 Dec 2020 18:46:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=pLn7QPvqMkwg2vptFv27Y3eT1Q9EmwqKOcR4476GRek=;
        b=UW2o4dtqHjAV5x6Lywz604nlxJr5qJJKRldnwL1I0CE63wgRjnmK1RQzIuv8pkyFfz
         1BewErNX688NI+631S7rmLxKFexriT3KmPKEElPNHkIYiKZ8On/2OW/EeBX7PcVc9QCC
         EgQWekWY0u8rpj3qjMEor9UilATvzRe4alS3ya0QIhpLH1U55RGebyA4rf4qEfgxJ/zY
         etfVRV6ywEtaPiBLIPJLR9MXvPHMW601xmxP8KMTnAvH95tAQPqX+cWcZzEw1gq/V/ht
         UtWKyy7spAllPb96K3VHo6NVwtzAsHbRa3EjpJ3JiMgUJLegME6ydocHglvqGg5pMBdV
         0U1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pLn7QPvqMkwg2vptFv27Y3eT1Q9EmwqKOcR4476GRek=;
        b=ZRuqbpg9TmyevGywJai4tEb+Fxrd40QbVz5wh6GPMRuCd0Nh4+6Tmn7tgitVec/y9L
         ZuVPcjdPrJegDecJgrn1xlHkQ2nBcceFruf4T9Up1y3ua/CxOxwqtW5H0h7yt1rTGUEW
         he1yHGGSDGzmoJulrhaJPzNY/SxJ5qiMoaZd+ApgDN1t8flbVWWB2FB8kOgfvHjObjAT
         rpPv0GKP/cLWbXCXBdSY+0tqyrApY78pfb2iBRUFkhnulZLzvlE9YAJlCUadwAQBCto8
         Cjt1NkWFe18Zkl0UdBOroy7TX5r3SaKWOX7H6EAaoJIcc0VSTomCZTf7SSnslq7CFzm4
         HiAg==
X-Gm-Message-State: AOAM531Myrnik4fEOICW25Vtmz+cfDVEdntEdvEyCB3DQmyECoio1kzD
	3u1ii8ZLKwRT7jQjjFpdJoSpUJ35l8laTT+Yuw8=
X-Google-Smtp-Source: ABdhPJyT68lyVZEbYI7B2He7hD01RsR577llGhclLtfm/qfIps2/Bgn/cNJhNF29WyVGCriEx1HSeFnSm2edvJodwbs=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:90a:8b94:: with SMTP id
 z20mr136800pjn.1.1607712400949; Fri, 11 Dec 2020 10:46:40 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:20 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 03/16] kbuild: lto: fix module versioning
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

With CONFIG_MODVERSIONS, version information is linked into each
compilation unit that exports symbols. With LTO, we cannot use this
method as all C code is compiled into LLVM bitcode instead. This
change collects symbol versions into .symversions files and merges
them in link-vmlinux.sh where they are all linked into vmlinux.o at
the same time.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 .gitignore               |  1 +
 Makefile                 |  3 ++-
 arch/Kconfig             |  1 -
 scripts/Makefile.build   | 33 +++++++++++++++++++++++++++++++--
 scripts/Makefile.modpost |  6 +++++-
 scripts/link-vmlinux.sh  | 23 ++++++++++++++++++++++-
 6 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
index d01cda8e1177..44e34991875e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -41,6 +41,7 @@
 *.so.dbg
 *.su
 *.symtypes
+*.symversions
 *.tab.[ch]
 *.tar
 *.xz
diff --git a/Makefile b/Makefile
index bc867bc3ebda..a07e3909e5d0 100644
--- a/Makefile
+++ b/Makefile
@@ -1837,7 +1837,8 @@ clean: $(clean-dirs)
 		-o -name '.tmp_*.o.*' \
 		-o -name '*.c.[012]*.*' \
 		-o -name '*.ll' \
-		-o -name '*.gcno' \) -type f -print | xargs rm -f
+		-o -name '*.gcno' \
+		-o -name '*.*.symversions' \) -type f -print | xargs rm -f
 
 # Generate tags for editors
 # ---------------------------------------------------------------------------
diff --git a/arch/Kconfig b/arch/Kconfig
index 9b4f556fd777..953bf35bc3db 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -635,7 +635,6 @@ config HAS_LTO_CLANG
 	depends on !FTRACE_MCOUNT_USE_RECORDMCOUNT
 	depends on !KASAN
 	depends on !GCOV_KERNEL
-	depends on !MODVERSIONS
 	help
 	  The compiler and Kconfig options support building with Clang's
 	  LTO.
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 65d4bea937fa..d94fc9ab819d 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -166,6 +166,15 @@ ifdef CONFIG_MODVERSIONS
 #   the actual value of the checksum generated by genksyms
 # o remove .tmp_<file>.o to <file>.o
 
+ifdef CONFIG_LTO_CLANG
+# Generate .o.symversions files for each .o with exported symbols, and link these
+# to the kernel and/or modules at the end.
+cmd_modversions_c =								\
+	if $(NM) $@ 2>/dev/null | grep -q __ksymtab; then			\
+		$(call cmd_gensymtypes_c,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
+		    > $@.symversions;						\
+	fi;
+else
 cmd_modversions_c =								\
 	if $(OBJDUMP) -h $@ | grep -q __ksymtab; then				\
 		$(call cmd_gensymtypes_c,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
@@ -177,6 +186,7 @@ cmd_modversions_c =								\
 		rm -f $(@D)/.tmp_$(@F:.o=.ver);					\
 	fi
 endif
+endif
 
 ifdef CONFIG_FTRACE_MCOUNT_USE_RECORDMCOUNT
 # compiler will not generate __mcount_loc use recordmcount or recordmcount.pl
@@ -386,6 +396,18 @@ $(obj)/%.asn1.c $(obj)/%.asn1.h: $(src)/%.asn1 $(objtree)/scripts/asn1_compiler
 $(subdir-builtin): $(obj)/%/built-in.a: $(obj)/% ;
 $(subdir-modorder): $(obj)/%/modules.order: $(obj)/% ;
 
+# combine symversions for later processing
+quiet_cmd_update_lto_symversions = SYMVER  $@
+ifeq ($(CONFIG_LTO_CLANG) $(CONFIG_MODVERSIONS),y y)
+      cmd_update_lto_symversions =					\
+	rm -f $@.symversions						\
+	$(foreach n, $(filter-out FORCE,$^),				\
+		$(if $(wildcard $(n).symversions),			\
+			; cat $(n).symversions >> $@.symversions))
+else
+      cmd_update_lto_symversions = echo >/dev/null
+endif
+
 #
 # Rule to compile a set of .o files into one .a file (without symbol table)
 #
@@ -393,8 +415,11 @@ $(subdir-modorder): $(obj)/%/modules.order: $(obj)/% ;
 quiet_cmd_ar_builtin = AR      $@
       cmd_ar_builtin = rm -f $@; $(AR) cDPrST $@ $(real-prereqs)
 
+quiet_cmd_ar_and_symver = AR      $@
+      cmd_ar_and_symver = $(cmd_update_lto_symversions); $(cmd_ar_builtin)
+
 $(obj)/built-in.a: $(real-obj-y) FORCE
-	$(call if_changed,ar_builtin)
+	$(call if_changed,ar_and_symver)
 
 #
 # Rule to create modules.order file
@@ -414,8 +439,11 @@ $(obj)/modules.order: $(obj-m) FORCE
 #
 # Rule to compile a set of .o files into one .a file (with symbol table)
 #
+quiet_cmd_ar_lib = AR      $@
+      cmd_ar_lib = $(cmd_update_lto_symversions); $(cmd_ar)
+
 $(obj)/lib.a: $(lib-y) FORCE
-	$(call if_changed,ar)
+	$(call if_changed,ar_lib)
 
 # NOTE:
 # Do not replace $(filter %.o,^) with $(real-prereqs). When a single object
@@ -424,6 +452,7 @@ $(obj)/lib.a: $(lib-y) FORCE
 ifdef CONFIG_LTO_CLANG
 quiet_cmd_link_multi-m = AR [M]  $@
 cmd_link_multi-m =						\
+	$(cmd_update_lto_symversions);				\
 	rm -f $@; 						\
 	$(AR) cDPrsT $@ $(filter %.o,$^)
 else
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 9ff8bfdb574d..066beffca09a 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -111,7 +111,11 @@ ifdef CONFIG_LTO_CLANG
 prelink-ext := .lto
 
 quiet_cmd_cc_lto_link_modules = LTO [M] $@
-cmd_cc_lto_link_modules = $(LD) $(ld_flags) -r -o $@ --whole-archive $^
+cmd_cc_lto_link_modules =						\
+	$(LD) $(ld_flags) -r -o $@					\
+		$(shell [ -s $(@:.lto.o=.o.symversions) ] &&		\
+			echo -T $(@:.lto.o=.o.symversions))		\
+		--whole-archive $^
 
 %.lto.o: %.o
 	$(call if_changed,cc_lto_link_modules)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 596507573a48..78e55fe7210b 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -43,11 +43,26 @@ info()
 	fi
 }
 
+# If CONFIG_LTO_CLANG is selected, collect generated symbol versions into
+# .tmp_symversions.lds
+gen_symversions()
+{
+	info GEN .tmp_symversions.lds
+	rm -f .tmp_symversions.lds
+
+	for o in ${KBUILD_VMLINUX_OBJS} ${KBUILD_VMLINUX_LIBS}; do
+		if [ -f ${o}.symversions ]; then
+			cat ${o}.symversions >> .tmp_symversions.lds
+		fi
+	done
+}
+
 # Link of vmlinux.o used for section mismatch analysis
 # ${1} output file
 modpost_link()
 {
 	local objects
+	local lds=""
 
 	objects="--whole-archive				\
 		${KBUILD_VMLINUX_OBJS}				\
@@ -57,6 +72,11 @@ modpost_link()
 		--end-group"
 
 	if [ -n "${CONFIG_LTO_CLANG}" ]; then
+		if [ -n "${CONFIG_MODVERSIONS}" ]; then
+			gen_symversions
+			lds="${lds} -T .tmp_symversions.lds"
+		fi
+
 		# This might take a while, so indicate that we're doing
 		# an LTO link
 		info LTO ${1}
@@ -64,7 +84,7 @@ modpost_link()
 		info LD ${1}
 	fi
 
-	${LD} ${KBUILD_LDFLAGS} -r -o ${1} ${objects}
+	${LD} ${KBUILD_LDFLAGS} -r -o ${1} ${lds} ${objects}
 }
 
 objtool_link()
@@ -242,6 +262,7 @@ cleanup()
 {
 	rm -f .btf.*
 	rm -f .tmp_System.map
+	rm -f .tmp_symversions.lds
 	rm -f .tmp_vmlinux*
 	rm -f System.map
 	rm -f vmlinux
-- 
2.29.2.576.ga3fc446d84-goog

