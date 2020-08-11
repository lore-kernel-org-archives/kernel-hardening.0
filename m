Return-Path: <SRS0=tR2c=BV=lists.openwall.com=kernel-hardening-return-19592-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C06A7C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 13:08:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1C7762076C
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 13:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8RMOZT7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C7762076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19592-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17925 invoked by uid 550); 11 Aug 2020 13:08:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17895 invoked from network); 11 Aug 2020 13:08:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1597151279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GEcUQe9UY6xIXezS6UK1KppXLYMBh6QTCdnZ8sG8rsY=;
	b=b8RMOZT7S15LfTx8cyS/VOurV3QUGT7zYUod0G9frMYAin/CUapro1mP3NQkX2AiOtpeje
	NxL/hJKD+DjyGrzgewajO2+BPKb2CrSQP4HjmLxoSxAh358wpF7W9gpq90OCZFPK102lLd
	B0debG7a10TikAUuPfQ38RQA39G9yPk=
X-MC-Unique: xDkIZWOiMMyhcP7SUKS3CQ-1
From: Steve Grubb <sgrubb@redhat.com>
To: David Laight <David.Laight@aculab.com>, Al Viro <viro@zeniv.linux.org.uk>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Deven Bowers <deven.desai@linux.microsoft.com>, Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@mi
 crosoft.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thibaut Sautereau <thibaut.sautereau@clip-os.org>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
Date: Tue, 11 Aug 2020 09:07:41 -0400
Message-ID: <2542427.mvXUDI8C0e@x2>
Organization: Red Hat
In-Reply-To: <c0224c08-f669-168e-3bb4-35eceec96a8b@digikod.net>
References: <20200723171227.446711-1-mic@digikod.net> <26a4a8378f3b4ad28eaa476853092716@AcuMS.aculab.com> <c0224c08-f669-168e-3bb4-35eceec96a8b@digikod.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

On Tuesday, August 11, 2020 4:50:53 AM EDT Micka=EBl Sala=FCn wrote:
> On 11/08/2020 10:09, David Laight wrote:
> >> On 11/08/2020 00:28, Al Viro wrote:
> >>> On Mon, Aug 10, 2020 at 10:09:09PM +0000, David Laight wrote:
> >>>>> On Mon, Aug 10, 2020 at 10:11:53PM +0200, Micka=EBl Sala=FCn wrote:
> >>>>>> It seems that there is no more complains nor questions. Do you want
> >>>>>> me
> >>>>>> to send another series to fix the order of the S-o-b in patch 7?
> >>>>>=20
> >>>>> There is a major question regarding the API design and the choice of
> >>>>> hooking that stuff on open().  And I have not heard anything
> >>>>> resembling
> >>>>> a coherent answer.
> >>>>=20
> >>>> To me O_MAYEXEC is just the wrong name.
> >>>> The bit would be (something like) O_INTERPRET to indicate
> >>>> what you want to do with the contents.
> >>=20
> >> The properties is "execute permission". This can then be checked by
> >> interpreters or other applications, then the generic O_MAYEXEC name.
> >=20
> > The english sense of MAYEXEC is just wrong for what you are trying
> > to check.
>=20
> We think it reflects exactly what it's purpose is.
>=20
> >>> ... which does not answer the question - name of constant is the least
> >>> of
> >>> the worries here.  Why the hell is "apply some unspecified checks to
> >>> file" combined with opening it, rather than being an independent
> >>> primitive
> >>> you apply to an already opened file?  Just in case - "'cuz that's how
> >>> we'd
> >>> done it" does not make a good answer...
> >=20
> > Maybe an access_ok() that acts on an open fd would be more
> > appropriate.
> > Which might end up being an fcntrl() action.
> > That would give you a full 32bit mask of options.
>=20
> I previously talk about fcntl(2):
> https://lore.kernel.org/lkml/eaf5bc42-e086-740b-a90c-93e67c535eee@digikod=
=2En
> et/

=46cntl is too late for anything using FANOTIFY. Everything needs to be upf=
ront=20
or other security systems cannot use it.

=2DSteve


