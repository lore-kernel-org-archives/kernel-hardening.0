Return-Path: <SRS0=qjxi=BV=lists.openwall.com=kernel-hardening-return-19594-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0264AC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 13:58:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 26553204FD
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 13:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LIYH+A7l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26553204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19594-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9743 invoked by uid 550); 11 Aug 2020 13:58:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9718 invoked from network); 11 Aug 2020 13:57:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=8+VNdHlhxOvRbCRm5OQf10+CgqIoZ02tkybxKOp4+V8=;
 b=LIYH+A7lEb5N0LnxZTy2LzZ9FpOhzSz3qHyH54O17nVkXBrHE0JNOOJEwsY7VXv5dr17
 Bdfk2H5Musw7vGAQK/wrDgi/YzKXqjSRRJtEBxycJN3KHK1668idCUO6P6sK/ULWeRtO
 WWKiRpo9kYRpMFa10aq8jtnp8NsSO8FXwqOiq4SlVBlJqXpXmpnosry/ClIMtcGk+xL1
 8osdpZSsdSiA1+D/lU8EtPZCN0uYwClu7GQtv3aiSOupRoXL91yCXuBadWxGUzDBs5g0
 R0Hk5PjHjgZefqcURv5FgpCXi5fcW2f1FCc9g+FReRCALaUBHE7R570i6MINeEWValSP Lg== 
Message-ID: <5db0ef9cb5e7e1569a5a1f7a0594937023f7290b.camel@linux.ibm.com>
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Jann Horn
	 <jannh@google.com>, Kees Cook <keescook@chromium.org>,
        Deven Bowers
	 <deven.desai@linux.microsoft.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
        Andy
 Lutomirski <luto@kernel.org>,
        Christian Brauner
 <christian.brauner@ubuntu.com>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
        Jan
 Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        Matthew Garrett
 <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk
 <mtk.manpages@gmail.com>,
        Philippe =?ISO-8859-1?Q?Tr=E9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean
 Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan
 <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
        Steve Grubb
 <sgrubb@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,
        Kernel Hardening
 <kernel-hardening@lists.openwall.com>,
        Linux API
 <linux-api@vger.kernel.org>,
        linux-integrity@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Tue, 11 Aug 2020 09:56:50 -0400
In-Reply-To: <0cc94c91-afd3-27cd-b831-8ea16ca8ca93@digikod.net>
References: <20200723171227.446711-1-mic@digikod.net>
	 <202007241205.751EBE7@keescook>
	 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net>
	 <20200810202123.GC1236603@ZenIV.linux.org.uk>
	 <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
	 <CAG48ez0NAV5gPgmbDaSjo=zzE=FgnYz=-OHuXwu0Vts=B5gesA@mail.gmail.com>
	 <0cc94c91-afd3-27cd-b831-8ea16ca8ca93@digikod.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-11_13:2020-08-11,2020-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008110091

On Tue, 2020-08-11 at 10:48 +0200, Mickaël Salaün wrote:
> On 11/08/2020 01:03, Jann Horn wrote:
> > On Tue, Aug 11, 2020 at 12:43 AM Mickaël Salaün <mic@digikod.net> wrote:
> > > On 10/08/2020 22:21, Al Viro wrote:
> > > > On Mon, Aug 10, 2020 at 10:11:53PM +0200, Mickaël Salaün wrote:
> > > > > It seems that there is no more complains nor questions. Do you want me
> > > > > to send another series to fix the order of the S-o-b in patch 7?
> > > > 
> > > > There is a major question regarding the API design and the choice of
> > > > hooking that stuff on open().  And I have not heard anything resembling
> > > > a coherent answer.
> > > 
> > > Hooking on open is a simple design that enables processes to check files
> > > they intend to open, before they open them. From an API point of view,
> > > this series extends openat2(2) with one simple flag: O_MAYEXEC. The
> > > enforcement is then subject to the system policy (e.g. mount points,
> > > file access rights, IMA, etc.).
> > > 
> > > Checking on open enables to not open a file if it does not meet some
> > > requirements, the same way as if the path doesn't exist or (for whatever
> > > reasons, including execution permission) if access is denied.
> > 
> > You can do exactly the same thing if you do the check in a separate
> > syscall though.
> > 
> > And it provides a greater degree of flexibility; for example, you can
> > use it in combination with fopen() without having to modify the
> > internals of fopen() or having to use fdopen().
> > 
> > > It is a
> > > good practice to check as soon as possible such properties, and it may
> > > enables to avoid (user space) time-of-check to time-of-use (TOCTOU)
> > > attacks (i.e. misuse of already open resources).
> > 
> > The assumption that security checks should happen as early as possible
> > can actually cause security problems. For example, because seccomp was
> > designed to do its checks as early as possible, including before
> > ptrace, we had an issue for a long time where the ptrace API could be
> > abused to bypass seccomp filters.
> > 
> > Please don't decide that a check must be ordered first _just_ because
> > it is a security check. While that can be good for limiting attack
> > surface, it can also create issues when the idea is applied too
> > broadly.
> 
> I'd be interested with such security issue examples.
> 
> I hope that delaying checks will not be an issue for mechanisms such as
> IMA or IPE:
> https://lore.kernel.org/lkml/1544699060.6703.11.camel@linux.ibm.com/
> 
> Any though Mimi, Deven, Chrome OS folks?

One of the major gaps, defining a system wide policy requiring all code
being executed to be signed, is interpreters.  The kernel has no
context for the interpreter's opening the file.  From an IMA
perspective, this information needs to be conveyed to the kernel prior
to ima_file_check(), which would allow IMA policy rules to be defined
in terms of O_MAYEXEC.

> 
> > I don't see how TOCTOU issues are relevant in any way here. If someone
> > can turn a script that is considered a trusted file into an untrusted
> > file and then maliciously change its contents, you're going to have
> > issues either way because the modifications could still happen after
> > openat(); if this was possible, the whole thing would kind of fall
> > apart. And if that isn't possible, I don't see any TOCTOU.
> 
> Sure, and if the scripts are not protected in some way there is no point
> to check anything.

The interpreter itself would be signed.

Mimi

> 
> > > It is important to keep
> > > in mind that the use cases we are addressing consider that the (user
> > > space) script interpreters (or linkers) are trusted and unaltered (i.e.
> > > integrity/authenticity checked). These are similar sought defensive
> > > properties as for SUID/SGID binaries: attackers can still launch them
> > > with malicious inputs (e.g. file paths, file descriptors, environment
> > > variables, etc.), but the binaries can then have a way to check if they
> > > can extend their trust to some file paths.
> > > 
> > > Checking file descriptors may help in some use cases, but not the ones
> > > motivating this series.
> > 
> > It actually provides a superset of the functionality that your
> > existing patches provide.
> 
> It also brings new issues with multiple file descriptor origins (e.g.
> memfd_create).
> 
> > > Checking (already) opened resources could be a
> > > *complementary* way to check execute permission, but it is not in the
> > > scope of this series.


