Return-Path: <SRS0=ftPS=G4=lists.openwall.com=kernel-hardening-return-20701-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA30C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Jan 2021 17:22:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C730A22B3B
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Jan 2021 17:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C730A22B3B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20701-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20158 invoked by uid 550); 25 Jan 2021 17:21:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20138 invoked from network); 25 Jan 2021 17:21:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1611595301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oy0AKF3Df9SxaEtjOgXKvjIedXAQG2J7MgGjy1hTE4k=;
	b=ICRLY48XM2RekUJDqlWQnPDlK50GJxsPPWSCbvIH8UaOmFKwY5WA5F+ISvKwHOj8E+z7s6
	egqA+wRyvE+dP+SYIC1eyNEqfMd8RcXxrLJmklbC34K2hsTenOUTI+fjMx8g+IuSDR+dTe
	kkQnqZVkWwq21qo9FENkrnN2o78os+M=
X-MC-Unique: UXZvFWYkNM2HgeJw9jbWVA-1
Date: Mon, 25 Jan 2021 11:21:24 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Fangrui Song <maskray@google.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Miroslav Benes <mbenes@suse.cz>, Kees Cook <keescook@chromium.org>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	live-patching@vger.kernel.org, Hongjiu Lu <hongjiu.lu@intel.com>,
	joe.lawrence@redhat.com
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20210125172124.awabevkpvq4poqxf@treble>
References: <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
 <20200722160730.cfhcj4eisglnzolr@treble>
 <202007221241.EBC2215A@keescook>
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
 <20200722213313.aetl3h5rkub6ktmw@treble>
 <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
 <alpine.LSU.2.21.2008281216031.29208@pobox.suse.cz>
 <20200828192413.p6rctr42xtuh2c2e@treble>
 <20210123225928.z5hkmaw6qjs2gu5g@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210123225928.z5hkmaw6qjs2gu5g@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

On Sat, Jan 23, 2021 at 02:59:28PM -0800, Fangrui Song wrote:
> On 2020-08-28, Josh Poimboeuf wrote:
> > On Fri, Aug 28, 2020 at 12:21:13PM +0200, Miroslav Benes wrote:
> > > > Hi there! I was trying to find a super easy way to address this, so I
> > > > thought the best thing would be if there were a compiler or linker
> > > > switch to just eliminate any duplicate symbols at compile time for
> > > > vmlinux. I filed this question on the binutils bugzilla looking to see
> > > > if there were existing flags that might do this, but H.J. Lu went ahead
> > > > and created a new one "-z unique", that seems to do what we would need
> > > > it to do.
> > > >
> > > > https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> > > >
> > > > When I use this option, it renames any duplicate symbols with an
> > > > extension - for example duplicatefunc.1 or duplicatefunc.2. You could
> > > > either match on the full unique name of the specific binary you are
> > > > trying to patch, or you match the base name and use the extension to
> > > > determine original position. Do you think this solution would work?
> > > 
> > > Yes, I think so (thanks, Joe, for testing!).
> > > 
> > > It looks cleaner to me than the options above, but it may just be a matter
> > > of taste. Anyway, I'd go with full name matching, because -z unique-symbol
> > > would allow us to remove sympos altogether, which is appealing.
> > > 
> > > > If
> > > > so, I can modify livepatch to refuse to patch on duplicated symbols if
> > > > CONFIG_FG_KASLR and when this option is merged into the tool chain I
> > > > can add it to KBUILD_LDFLAGS when CONFIG_FG_KASLR and livepatching
> > > > should work in all cases.
> > > 
> > > Ok.
> > > 
> > > Josh, Petr, would this work for you too?
> > 
> > Sounds good to me.  Kristen, thanks for finding a solution!
> 
> (I am not subscribed. I came here via https://sourceware.org/bugzilla/show_bug.cgi?id=26391 (ld -z unique-symbol))
> 
> > This works great after randomization because it always receives the
> > current address at runtime rather than relying on any kind of
> > buildtime address. The issue with with the live-patching code's
> > algorithm for resolving duplicate symbol names. If they request a
> > symbol by name from the kernel and there are 3 symbols with the same
> > name, they use the symbol's position in the built binary image to
> > select the correct symbol.
> 
> If a.o, b.o and c.o define local symbol 'foo'.
> By position, do you mean that
> 
> * the live-patching code uses something like (findall("foo")[0], findall("foo")[1], findall("foo")[2]) ?

Yes, it depends on their order in the symbol table of the linked binary
(vmlinux).

> * shuffling a.o/b.o/c.o will make the returned triple different

Yes, though it's actually functions that get shuffled.

> Local symbols are not required to be unique. Instead of patching the toolchain,
> have you thought about making the live-patching code smarter?

It's a possibility (more on that below).

> (Depend on the duplicates, such a linker option can increase the link time/binary size considerably

Have you tried it on vmlinux?  Just wondering what the time/size impact
would be in real-world numbers.

Duplicate symbols make up a very small percentage of all symbols in the
kernel, so I would think the binary size change (to the strtab?) would
be insignificant?

> AND I don't know in what other cases such an option will be useful)

I believe some other kernel components (tracing, kprobes, bpf) have the
same problem as livepatch with respect to disambiguating duplicate
symbols, for the purposes of tracing/debugging.  So I'm thinking it
would be a nice overall improvement to the kernel.

> For the following example,
> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=26822
> 
>   # RUN: split-file %s %t
>   # RUN: gcc -c %t/a.s -o %t/a.o
>   # RUN: gcc -c %t/b.s -o %t/b.o
>   # RUN: gcc -c %t/c.s -o %t/c.o
>   # RUN: ld-new %t/a.o %t/b.o %t/c.o -z unique-symbol -o %t.exe
>   #--- a.s
>   a: a.1: a.2: nop
>   #--- b.s
>   a: nop
>   #--- c.s
>   a: nop
> 
> readelf -Ws output:
> 
> Symbol table '.symtab' contains 13 entries:
>    Num:    Value          Size Type    Bind   Vis      Ndx Name
>      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND      1:
> 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS a.o
>      2: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a
>      3: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a.1
>      4: 0000000000401000     0 NOTYPE  LOCAL  DEFAULT    1 a.2
>      5: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS b.o
>      6: 0000000000401001     0 NOTYPE  LOCAL  DEFAULT    1 a.1
>      7: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS c.o
>      8: 0000000000401002     0 NOTYPE  LOCAL  DEFAULT    1 a.2
>      9: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _start
>     10: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 __bss_start
>     11: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 _edata
>     12: 0000000000402000     0 NOTYPE  GLOBAL DEFAULT    1 _end
> 
> Note that you have STT_FILE SHN_ABS symbols.
> If the compiler does not produce them, they will be synthesized by GNU ld.
> 
>   https://sourceware.org/bugzilla/show_bug.cgi?id=26822
>   ld.bfd copies non-STT_SECTION local symbols from input object files.  If an
>   object file does not have STT_FILE symbols (no .file directive) but has
>   non-STT_SECTION local symbols, ld.bfd synthesizes a STT_FILE symbol

Right, I see what you're getting at.  As far as I can tell, there are
potentially two ways for fgkaslr to handle this:

a) shuffle files, not functions.  i.e. keep the functions' order intact
   within the STT_FILE group, shuffling the file groups themselves.

   (NOTE: this may have an additional benefit of improving i-cache
   performance, compared to the current fgkaslr implementation.)

   or

b) shuffle functions, keeping track of what file they belonged to.

Maybe Kristen could comment on the feasibility of either of these
options.  I believe the STT_FILE symbols are not currently available to
the kernel at runtime.  They would need to be made available to both
fgkaslr and livepatch code.

Overall "ld -z unique-symbol" would be much easier from a kernel
standpoint, and would benefit multiple components as I mentioned above.

> The filenames are usually base names, so "a.o" and "a.o" in two directories will
> be indistinguishable.  The live-patching code can possibly work around this by
> not changing the relative order of the two "a.o".

Right, there are some file:func duplicates so this case would indeed
need to be handled somehow.

$ readelf -s --wide vmlinux |awk '$4 == "FILE" {file=$8; next} $4 == "FUNC" {printf "%s:%s\n", file, $8}' |sort |uniq -d
bus.c:new_id_store
core.c:cmask_show
core.c:edge_show
core.c:event_show
core.c:inv_show
core.c:paravirt_read_msr
core.c:paravirt_read_msr_safe
core.c:type_show
core.c:umask_show
hid-core.c:hid_exit
hid-core.c:hid_init
inode.c:init_once
inode.c:remove_one
msr.c:msr_init
proc.c:c_next
proc.c:c_start
proc.c:c_stop
raw.c:dst_output
raw.c:raw_ioctl
route.c:dst_discard
super.c:init_once
udp.c:udp_lib_close
udp.c:udp_lib_hash
udp.c:udplite_getfrag
udplite.c:udp_lib_close
udplite.c:udp_lib_hash
udplite.c:udplite_sk_init

-- 
Josh

