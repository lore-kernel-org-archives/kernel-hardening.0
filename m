Return-Path: <SRS0=b39O=C4=lists.openwall.com=kernel-hardening-return-19953-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F344C43464
	for <kernel-hardening@archiver.kernel.org>; Sat, 19 Sep 2020 08:03:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9B8D721481
	for <kernel-hardening@archiver.kernel.org>; Sat, 19 Sep 2020 08:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="gCp0Pxfe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B8D721481
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19953-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16082 invoked by uid 550); 19 Sep 2020 08:02:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16062 invoked from network); 19 Sep 2020 08:02:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1600502522;
	bh=4XgdFtvAi6R4B5XmudteHuz8hEx5VkQonxbFFxSLuwY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gCp0Pxfe1yp36A3FUcn3Ym16DzjHZUgk64Ut9YWbXYe/BKi3p8cyxtAJI0hgpxtYP
	 e0+AlAlOyP8R57EgIGKVjk4e38bY9yau4aydPoEJ9autBnx7bJm9yJroWGVQs8csFs
	 jPkF+SEyN4GWAfOSKf5in74y2MfJDeGl+9Aq+Vjo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sat, 19 Sep 2020 10:01:43 +0200
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: John Wood <john.wood@gmx.com>, kernel-hardening@lists.openwall.com,
	Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] security/fbfam: Mitigate a fork brute force
 attack
Message-ID: <20200919080143.GA2998@ubuntu>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-7-keescook@chromium.org>
 <202009101649.2A0BF95@keescook>
 <20200918152116.GB3229@ubuntu>
 <202009181433.EAF237C36@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009181433.EAF237C36@keescook>
X-Provags-ID: V03:K1:9L/Tjnvsa4rFId2m/ThIutvMMgMjZ/IzDuYdTCkaziufEFzDKT/
 IRrFLRh5iZZijoWA9cyyfuQ4k6jgKMd25Kk8d4GzwKnS21hKdASly6qgEiapWsHmSbTaFO+
 ENvVfY9y27mz4HzAjPWRFPwB2wIeSzoU1ixZMKt41hEE37FmLQuxey8tSSV1y7BasThZLWK
 UFxckuz1NmniW0O7Dq3Tw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DsrSIZNTKX4=:fcgG2vxOYNU28XvduGgWSa
 l8OZ/b33w3ZI6C2efMkW4M4v7bTdHnASMI4IqpDRJr818NfR2aEPc0wQF/se2ZEijsoc+fbZm
 g6oyJlTgpJSpsWyfvKwOSmljP4gX09HDMTHcVypA7NU+ujsxjA58GmgDEzM/a8tQT0maE6MkT
 84zWkocT9nX/OtvYtNW5b1/JijWJkxtRk61NJPv14n1twCS8Mzl3Tw643fLm2K3wzEB8bnjGc
 OmlW6f04gTRYuNs5JpPApQxOCM6P4btmbltAm99vq9C8V4QWGrqSnlAPBArJf9/tzIjdTl/ZV
 cfAso21lbNzw9SFeRQyweLS/zOflRENFU9ISWCBnulBelTGqKi5S9MOtt4WkPJHbnTp0vXAOE
 Y3K++PK1wcas5NxxoCltB/JlKLdQz6dxsR3OgCEXpcieMaOyxxzsLHLvZYH1rmMGHGD1gbsAu
 VVzBIZ8dc3GFVnmGRTUL+VJfk+9P+LXhtSEcs29a2mWA6gs9997OxBHVz0Oqpqci1J/nqxs9y
 LG4jzr9JCMOqkF8xexq410aveWcLckUQp4k2RA+BQrk26YC+kN0Mj9Xse78p4EN96svVeLKbj
 Lqlj5k1+KEqd1qJfnhCxEG3suUQhW3xQh354D2+q45dSf1FlqlnBpbFzBt2wvVNq26prssG/X
 KK0vyakF7pgD5Wx9sV3XRmV6Zm4QuoTN+ZTnHHSLwgIICtSnrVQVLzn8GsKAbZtXYdPVc3Avl
 xvhafXunIOq2wROMVBjr9Z7srPprj1rUFtQdz0Nwlm/he+HlVwvSa8KcTazoXWepxIdyF7+HV
 BbSCC5D3Lk/DWhSkQ84CK5NIVlH8auL3JXuiT5AtkGNzzgPBf/hMpvP4GKhrVcY7fsmVTP0ow
 LkFRL7xchZ9ergYtr90Euxz6nV0Ko71ORgua7sVn+IeijeftZHqB3+ASSRommPaZzMeFNWKtQ
 8j3sW3Zy4NNNdmi0BKNpV1FHOiQQKHNedyCUm4QTeQUALWHQxDr1lETNzG8O9iDvzpAZHa4SV
 W9bN3Iik9vt0yh8POyczQC94lONDsRZ1duce+iDjqfvdH8U239jL2GNwWyxOGfLzRHIHgdnT+
 UtdphSgI1cUGccdFzgH1EtmPf7mGGyAB2utUt75IHNLONIrMAfTxpK7eNTlSrTS4BPtbbM4e2
 e5Fk8i4DtMwmE1+qey/Od3qJdIcnFM3e1UUlGMI0Q3xOc4ZQsLqUYtDyzUzMcx+Iwlx5LkWCw
 tJj4wRrbj6ekneFnF4EzqQplU3U5eCTOuu4LMaQ==
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 18, 2020 at 02:35:12PM -0700, Kees Cook wrote:
> On Fri, Sep 18, 2020 at 06:02:16PM +0200, John Wood wrote:
> > On Thu, Sep 10, 2020 at 04:56:19PM -0700, Kees Cook wrote:
> > > On Thu, Sep 10, 2020 at 01:21:07PM -0700, Kees Cook wrote:
> > > > +		pr_warn("fbfam: Offending process with PID %d killed\n",
> > > > +			p->pid);
> > >
> > > I'd make this ratelimited (along with Jann's suggestions).
> >
> > Sorry, but I don't understand what you mean with "make this ratelimite=
d".
> > A clarification would be greatly appreciated.
>
> Ah! Yes, sorry for not being more clear. There are ratelimit helpers for
> the pr_*() family of functions, e.g.:
>
> 	pr_warn_ratelimited("brute: Offending process with PID...

Thanks for the clarification.

> --
> Kees Cook

Regards,
John Wood
