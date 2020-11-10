Return-Path: <SRS0=doVZ=EQ=lists.openwall.com=kernel-hardening-return-20377-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978F9C55ABD
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 16:12:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E04D20797
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 16:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZAlCen6n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E04D20797
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20377-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32493 invoked by uid 550); 10 Nov 2020 16:12:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32464 invoked from network); 10 Nov 2020 16:12:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605024706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jp+HmPlYtR2IGGTGzYIzvrsfgydKFOm7mlacIEpnzOM=;
	b=ZAlCen6nBxHdvB++lXI9iB2wUc2fR7S1sn8a4M7aStoSiWD61XLeZlkFKBJm2qCKaL9c1n
	jgzZQ1CjNuQ5h6tktn3PxLjqNQyuPR+ydGJYTBs9u3RYaHmDokPnhzLAi/0v9ufTLA68YW
	bWCtGS5HDV+q2NdO1yrdq0ovrv6cEeU=
X-MC-Unique: 5kzcWzDFO8i3LtgKf7nZng-1
Date: Tue, 10 Nov 2020 10:11:24 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201110161124.lztfgffqh2qrlwwv@treble>
References: <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
 <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com>
 <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble>
 <CABCJKuc_-Sxj8HLajx4pKuBpU3AUdBtPv4uzQfMWqVHWwHS1iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABCJKuc_-Sxj8HLajx4pKuBpU3AUdBtPv4uzQfMWqVHWwHS1iQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

On Mon, Nov 09, 2020 at 08:48:01PM -0800, Sami Tolvanen wrote:
> On Mon, Nov 9, 2020 at 6:29 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > How would I recreate all these warnings?
> 
> You can reproduce all of these using a normal gcc build without any of
> the LTO patches by running objtool check -arfld vmlinux.o. However,
> with gcc you'll see even more warnings due to duplicate symbol names,
> as Peter pointed out elsewhere in the thread, so I looked at only the
> warnings that objtool also prints with LTO.
> 
> Note that the LTO series contains a patch to split noinstr validation
> from --vmlinux, as we need to run objtool here even if
> CONFIG_VMLINUX_VALIDATION isn't selected, so I have not looked at the
> noinstr warnings. The latest LTO tree is available here:
> 
> https://github.com/samitolvanen/linux/commits/clang-lto
> 
> > Here's the patch for hopefully making the warnings more helpful:
> 
> Thanks, I'll give it a try.

Here's the version without the nonsensical debug warning :-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 4e1d7460574b..ced7e4754cba 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -217,6 +217,21 @@ struct symbol *find_func_containing(struct section *sec, unsigned long offset)
 	return NULL;
 }
 
+struct symbol *find_symbol_preceding(struct section *sec, unsigned long offset)
+{
+	struct symbol *sym;
+
+	/*
+	 * This is slow, but used for warning messages.
+	 */
+	while (1) {
+		sym = find_symbol_by_offset(sec, offset);
+		if (sym || !offset)
+			return sym;
+		offset--;
+	}
+}
+
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name)
 {
 	struct symbol *sym;
diff --git a/tools/objtool/elf.h b/tools/objtool/elf.h
index 807f8c670097..841902ed381e 100644
--- a/tools/objtool/elf.h
+++ b/tools/objtool/elf.h
@@ -136,10 +136,11 @@ struct symbol *find_func_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_offset(struct section *sec, unsigned long offset);
 struct symbol *find_symbol_by_name(const struct elf *elf, const char *name);
 struct symbol *find_symbol_containing(const struct section *sec, unsigned long offset);
+struct symbol *find_func_containing(struct section *sec, unsigned long offset);
+struct symbol *find_symbol_preceding(struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset);
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
 				     unsigned long offset, unsigned int len);
-struct symbol *find_func_containing(struct section *sec, unsigned long offset);
 int elf_rebuild_reloc_section(struct elf *elf, struct section *sec);
 
 #define for_each_sec(file, sec)						\
diff --git a/tools/objtool/warn.h b/tools/objtool/warn.h
index 7799f60de80a..33da0f2ed9d5 100644
--- a/tools/objtool/warn.h
+++ b/tools/objtool/warn.h
@@ -22,6 +22,8 @@ static inline char *offstr(struct section *sec, unsigned long offset)
 	unsigned long name_off;
 
 	func = find_func_containing(sec, offset);
+	if (!func)
+		func = find_symbol_preceding(sec, offset);
 	if (func) {
 		name = func->name;
 		name_off = offset - func->offset;

