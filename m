Return-Path: <SRS0=C9bl=XB=lists.openwall.com=kernel-hardening-return-16849-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411E1C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 17:41:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 811AF206A1
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 17:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="XO/yX7LE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 811AF206A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tycho.ws
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16849-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3803 invoked by uid 550); 6 Sep 2019 17:40:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3783 invoked from network); 6 Sep 2019 17:40:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=zO1msM12y6bK/8fdK5V2QvdumTJtX98CPZgVa4wYua8=;
        b=XO/yX7LEgs5Py5IcR0pKSxv0kqAvd7JX+EvT7RoHkRLj6XBdBgmc5kawEmQSEaOfCF
         befBBKyBZq+WQzNW+FffURQ7iannWXQeGXIpMnm2Hzrb0KAxm4qATsVouCrf8frCZRJq
         zJFo/9nCu8DmSzQW9l2UhDNx4m7+OQwYDWTXzt68joRfSKkOCyFG7v38va8fvVkDtCpe
         kUvye/5As7q+ij7ejRh5Wmz7WJ3EapCZ9iZOpGXBrkmaueHRg+beKqNU+1g3Hxef+haG
         Z/VemRSCEry5m2XrLM/UaS8LB0wsGl3bzSwE/TNObzcd7CM1464Tm7FWyYCP8aZTPfAg
         FmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=zO1msM12y6bK/8fdK5V2QvdumTJtX98CPZgVa4wYua8=;
        b=GE2QtDYijNkVbM/X4TbnbG2ALnC9VVv96RYrCNpazajabV8bpblI59m7Fb/e11qYFZ
         rFp0kkJReKcvpJE5l0YthVr7adZkHzqujY8DSI5usokD4Fg3IvWckHVLmjXGcB6Bbc66
         QBnVtnkfz9VzEsMyVibIo9YuAcVwQ4Em3YHUoRqGdpsq5ZjmrMBd1W/sBjkKtZc2pVAZ
         O21Dh/k+/DGVMtukZ6BlVilo7oZ87GgNjz4UrBsEIB1uQkwpE60rzwN+fH71zvcWsxUS
         9edHuHauORj7u6W0oKTPqEligud1SivnOx2SrCAbgh/7VsN8StGl/yKapHlSGTj/h7wh
         G0JQ==
X-Gm-Message-State: APjAAAVseJb26nQPCJlOzWLkz1AYk/QymJzVip8Hhx3dGEAXV0mQpvER
	oKLK8MggMhcQNQZh1lKbNaTU/Q==
X-Google-Smtp-Source: APXvYqw6HBNLBRT4qap2VlmNpFP0hpowdCfqD8xcG3thhHrNf1RI2l30UMgogsfSlYWSB6xKCbTu0g==
X-Received: by 2002:a62:b406:: with SMTP id h6mr11911803pfn.260.1567791644954;
        Fri, 06 Sep 2019 10:40:44 -0700 (PDT)
Date: Fri, 6 Sep 2019 11:40:41 -0600
From: Tycho Andersen <tycho@tycho.ws>
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Florian Weimer <fweimer@redhat.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Chiang <ericchiang@google.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Message-ID: <20190906174041.GH7627@cisco>
References: <20190906152455.22757-1-mic@digikod.net>
 <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <20190906170739.kk3opr2phidb7ilb@yavin.dot.cyphar.com>
 <20190906172050.v44f43psd6qc6awi@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190906172050.v44f43psd6qc6awi@wittgenstein>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Sep 06, 2019 at 07:20:51PM +0200, Christian Brauner wrote:
> On Sat, Sep 07, 2019 at 03:07:39AM +1000, Aleksa Sarai wrote:
> > On 2019-09-06, Mickaël Salaün <mickael.salaun@ssi.gouv.fr> wrote:
> > > 
> > > On 06/09/2019 17:56, Florian Weimer wrote:
> > > > Let's assume I want to add support for this to the glibc dynamic loader,
> > > > while still being able to run on older kernels.
> > > >
> > > > Is it safe to try the open call first, with O_MAYEXEC, and if that fails
> > > > with EINVAL, try again without O_MAYEXEC?
> > > 
> > > The kernel ignore unknown open(2) flags, so yes, it is safe even for
> > > older kernel to use O_MAYEXEC.
> > 
> > Depends on your definition of "safe" -- a security feature that you will
> > silently not enable on older kernels doesn't sound super safe to me.
> > Unfortunately this is a limitation of open(2) that we cannot change --
> > which is why the openat2(2) proposal I've been posting gives -EINVAL for
> > unknown O_* flags.
> > 
> > There is a way to probe for support (though unpleasant), by creating a
> > test O_MAYEXEC fd and then checking if the flag is present in
> > /proc/self/fdinfo/$n.
> 
> Which Florian said they can't do for various reasons.
> 
> It is a major painpoint if there's no easy way for userspace to probe
> for support. Especially if it's security related which usually means
> that you want to know whether this feature works or not.

What about just trying to violate the policy via fexecve() instead of
looking around in /proc? Still ugly, though.

Tycho
