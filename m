Return-Path: <kernel-hardening-return-21750-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id E803CC3271E
	for <kernel-hardening@archiver.kernel.org>; Mon,  8 Jul 2024 16:38:15 +0000 (UTC)
Received: (qmail 23804 invoked by uid 550); 8 Jul 2024 16:38:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23772 invoked from network); 8 Jul 2024 16:38:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720456674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MpE9tc6GwVBdyYEbRi90TJl4jv833e7Ek5Pw4E3TGJE=;
	b=fX8uSA2TkzAr1ioFIKYhuHpG0jv6nSBtLVPpRuAb7CjTg9S5IumTwc3AYBqlQwccOpEHKH
	dt+1ahr0q2zWCw6XqVP09Sd0lcU9Ku3k3aB/1IouWbJsz1JVigEkr3EQWcjLy4n7Hhqxj5
	AEu8lOBaHXE26PC6yj3zW9D9Lk4A2B0=
X-MC-Unique: S3QDT4-CPfOc0o7haGvhuw-1
From: Florian Weimer <fweimer@redhat.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  Christian Brauner
 <brauner@kernel.org>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds
 <torvalds@linux-foundation.org>,  Paul Moore <paul@paul-moore.com>,
  Theodore Ts'o <tytso@mit.edu>,  Alejandro Colomar <alx@kernel.org>,
  Aleksa Sarai <cyphar@cyphar.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Arnd
 Bergmann <arnd@arndb.de>,  Casey Schaufler <casey@schaufler-ca.com>,
  Christian Heimes <christian@python.org>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  Fan Wu <wufan@linux.microsoft.com>,  Geert
 Uytterhoeven <geert@linux-m68k.org>,  James Morris
 <jamorris@linux.microsoft.com>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jeff Xu <jeffxu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Jordan R Abrahams <ajordanr@google.com>,  Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,  Luca Boccassi
 <bluca@debian.org>,  Luis Chamberlain <mcgrof@kernel.org>,  "Madhavan T .
 Venkataraman" <madvenka@linux.microsoft.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Matthew Garrett <mjg59@srcf.ucam.org>,
  Matthew Wilcox <willy@infradead.org>,  Miklos Szeredi
 <mszeredi@redhat.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Nicolas
 Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Shuah Khan <shuah@kernel.org>,  Stephen Rothwell
 <sfr@canb.auug.org.au>,  Steve Dower <steve.dower@python.org>,  Steve
 Grubb <sgrubb@redhat.com>,  Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Xiaoming Ni <nixiaoming@huawei.com>,  Yin
 Fengwei <fengwei.yin@intel.com>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-security-module@vger.kernel.org, Eric Biederman
 <ebiederm@xmission.com>, linux-mm@kvack.org
Subject: [PATCH] binfmt_elf: Fail execution of shared objects with ELIBEXEC
 (was: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to
 execveat(2))
In-Reply-To: <20240708.zooj9Miaties@digikod.net> (=?utf-8?Q?=22Micka=C3=AB?=
 =?utf-8?Q?l_Sala=C3=BCn=22's?= message
	of "Mon, 8 Jul 2024 10:56:59 +0200")
References: <20240704190137.696169-1-mic@digikod.net>
	<20240704190137.696169-2-mic@digikod.net>
	<87bk3bvhr1.fsf@oldenburg.str.redhat.com>
	<20240706.poo9ahd3La9b@digikod.net>
	<871q46bkoz.fsf@oldenburg.str.redhat.com>
	<20240708.zooj9Miaties@digikod.net>
Date: Mon, 08 Jul 2024 18:37:14 +0200
Message-ID: <878qybet6t.fsf_-_@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

* Micka=C3=ABl Sala=C3=BCn:

> On Sat, Jul 06, 2024 at 05:32:12PM +0200, Florian Weimer wrote:
>> * Micka=C3=ABl Sala=C3=BCn:
>>=20
>> > On Fri, Jul 05, 2024 at 08:03:14PM +0200, Florian Weimer wrote:
>> >> * Micka=C3=ABl Sala=C3=BCn:
>> >>=20
>> >> > Add a new AT_CHECK flag to execveat(2) to check if a file would be
>> >> > allowed for execution.  The main use case is for script interpreter=
s and
>> >> > dynamic linkers to check execution permission according to the kern=
el's
>> >> > security policy. Another use case is to add context to access logs =
e.g.,
>> >> > which script (instead of interpreter) accessed a file.  As any
>> >> > executable code, scripts could also use this check [1].
>> >>=20
>> >> Some distributions no longer set executable bits on most shared objec=
ts,
>> >> which I assume would interfere with AT_CHECK probing for shared objec=
ts.
>> >
>> > A file without the execute permission is not considered as executable =
by
>> > the kernel.  The AT_CHECK flag doesn't change this semantic.  Please
>> > note that this is just a check, not a restriction.  See the next patch
>> > for the optional policy enforcement.
>> >
>> > Anyway, we need to define the policy, and for Linux this is done with
>> > the file permission bits.  So for systems willing to have a consistent
>> > execution policy, we need to rely on the same bits.
>>=20
>> Yes, that makes complete sense.  I just wanted to point out the odd
>> interaction with the old binutils bug and the (sadly still current)
>> kernel bug.
>>=20
>> >> Removing the executable bit is attractive because of a combination of
>> >> two bugs: a binutils wart which until recently always set the entry
>> >> point address in the ELF header to zero, and the kernel not checking =
for
>> >> a zero entry point (maybe in combination with an absent program
>> >> interpreter) and failing the execve with ELIBEXEC, instead of doing t=
he
>> >> execve and then faulting at virtual address zero.  Removing the
>> >> executable bit is currently the only way to avoid these confusing
>> >> crashes, so I understand the temptation.
>> >
>> > Interesting.  Can you please point to the bug report and the fix?  I
>> > don't see any ELIBEXEC in the kernel.
>>=20
>> The kernel hasn't been fixed yet.  I do think this should be fixed, so
>> that distributions can bring back the executable bit.
>
> Can you please point to the mailing list discussion or the bug report?

I'm not sure if this was ever reported upstream as an RFE to fail with
ELIBEXEC.  We have downstream bug report:

  Prevent executed .so files with e_entry =3D=3D 0 from attempting to become
  a process.
  <https://bugzilla.redhat.com/show_bug.cgi?id=3D2004942>

I've put together a patch which seems to work, see below.

I don't think there's any impact on AT_CHECK with execveat because that
mode will never get to this point.

Thanks,
Florian

---8<-----------------------------------------------------------------
Subject: binfmt_elf: Fail execution of shared objects with ELIBEXEC
=20=20=20=20
Historically, binutils has used the start of the text segment as the
entry point if _start was not defined.  Executing such files results
in crashes with random effects, depending on what code resides there.
However, starting with binutils 2.38, BFD ld uses a zero entry point,
due to commit 5226a6a892f922ea672e5775c61776830aaf27b7 ("Change the
linker's heuristic for computing the entry point for binaries so that
shared libraries default to an entry point of 0.").  This means
that shared objects with zero entry points are becoming more common,
and it makes sense for the kernel to recognize them and refuse
to execute them.

For backwards compatibility, if a load segment does not map the ELF
header at file offset zero, the kernel still proceeds as before, in
case the file is very non-standard and can actually start executing
at virtual offset zero.

Signed-off-by: Florian Weimer <fweimer@redhat.com>

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index a43897b03ce9..ebd7052eb616 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -830,6 +830,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	unsigned long e_entry;
 	unsigned long interp_load_addr =3D 0;
 	unsigned long start_code, end_code, start_data, end_data;
+	bool elf_header_mapped =3D false;
 	unsigned long reloc_func_desc __maybe_unused =3D 0;
 	int executable_stack =3D EXSTACK_DEFAULT;
 	struct elfhdr *elf_ex =3D (struct elfhdr *)bprm->buf;
@@ -865,6 +866,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			continue;
 		}
=20
+		if (elf_ppnt->p_type =3D=3D PT_LOAD && !elf_ppnt->p_offset)
+			elf_header_mapped =3D true;
+
 		if (elf_ppnt->p_type !=3D PT_INTERP)
 			continue;
=20
@@ -921,6 +925,20 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		goto out_free_ph;
 	}
=20
+	/*
+	 * A zero value for e_entry means that the ELF file has no
+	 * entry point.  If the ELF header is mapped, this is
+	 * guaranteed to crash (often even on the first instruction),
+	 * so fail the execve system call instead.  (This is most
+	 * likely to happen for a shared object.)  If the object has a
+	 * program interpreter, dealing with the situation is its
+	 * responsibility.
+	 */
+	if (elf_header_mapped && !elf_ex->e_entry && !interpreter) {
+		retval =3D -ELIBEXEC;
+		goto out_free_dentry;
+	}
+
 	elf_ppnt =3D elf_phdata;
 	for (i =3D 0; i < elf_ex->e_phnum; i++, elf_ppnt++)
 		switch (elf_ppnt->p_type) {

