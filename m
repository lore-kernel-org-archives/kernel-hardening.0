Return-Path: <SRS0=a61O=BG=lists.openwall.com=kernel-hardening-return-19454-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41820C433E5
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 05:27:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F39820759
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 05:27:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J1N5xDIR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F39820759
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19454-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17989 invoked by uid 550); 27 Jul 2020 05:27:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17966 invoked from network); 27 Jul 2020 05:27:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595827637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AKE5Hc2PxuPIW6hu7a7doCEJmqwBxswHHKiFGDtBWQs=;
	b=J1N5xDIRwcd9N36auM423VfEZG39rQiW4cG9RVJbrNbzm9vwJz1yfQHiCgGvEb/Iho9wG/
	7qcxYwRMs2n4ovJmdNI1bFlQJjv3oNu5mOhozEkvrt3v+jeIjSjUsX1EjCOx784jcIR5VF
	51jxaMjsj83uvNnKG4jPJRhQ3s9P7XA=
X-MC-Unique: WX2tJBGCNPCBLW1UaUOyYg-1
From: Florian Weimer <fweimer@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
  linux-kernel@vger.kernel.org,  Aleksa
 Sarai <cyphar@cyphar.com>,  Alexei Starovoitov <ast@kernel.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,
  Christian Brauner <christian.brauner@ubuntu.com>,  Christian Heimes
 <christian@python.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Deven
 Bowers <deven.desai@linux.microsoft.com>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  James Morris <jmorris@namei.org>,  Jan Kara
 <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,  Matthew Garrett
 <mjg59@google.com>,  Matthew Wilcox <willy@infradead.org>,  Michael
 Kerrisk <mtk.manpages@gmail.com>,  Mimi Zohar <zohar@linux.ibm.com>,
  Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Steve
 Dower <steve.dower@python.org>,  Steve Grubb <sgrubb@redhat.com>,  Tetsuo
 Handa <penguin-kernel@i-love.sakura.ne.jp>,  Thibaut Sautereau
 <thibaut.sautereau@clip-os.org>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-integrity@vger.kernel.org,
  linux-security-module@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Subject: Re: [PATCH v7 4/7] fs: Introduce O_MAYEXEC flag for openat2(2)
References: <20200723171227.446711-1-mic@digikod.net>
	<20200723171227.446711-5-mic@digikod.net>
	<20200727042106.GB794331@ZenIV.linux.org.uk>
Date: Mon, 27 Jul 2020 07:27:00 +0200
In-Reply-To: <20200727042106.GB794331@ZenIV.linux.org.uk> (Al Viro's message
	of "Mon, 27 Jul 2020 05:21:06 +0100")
Message-ID: <87y2n55xzv.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

* Al Viro:

> On Thu, Jul 23, 2020 at 07:12:24PM +0200, Micka=C3=83=C2=ABl Sala=C3=83=
=C2=BCn wrote:
>> When the O_MAYEXEC flag is passed, openat2(2) may be subject to
>> additional restrictions depending on a security policy managed by the
>> kernel through a sysctl or implemented by an LSM thanks to the
>> inode_permission hook.  This new flag is ignored by open(2) and
>> openat(2) because of their unspecified flags handling.  When used with
>> openat2(2), the default behavior is only to forbid to open a directory.
>
> Correct me if I'm wrong, but it looks like you are introducing a magical
> flag that would mean "let the Linux S&M take an extra special whip
> for this open()".
>
> Why is it done during open?  If the caller is passing it deliberately,
> why not have an explicit request to apply given torture device to an
> already opened file?  Why not sys_masochism(int fd, char *hurt_flavour),
> for that matter?

While I do not think this is appropriate language for a workplace, Al
has a point: If the auditing event can be generated on an already-open
descriptor, it would also cover scenarios like this one:

  perl < /path/to/script

Where the process that opens the file does not (and cannot) know that it
will be used for execution purposes.

Thanks,
Florian

