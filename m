Return-Path: <SRS0=DEic=IK=lists.openwall.com=kernel-hardening-return-20933-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A71C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Mar 2021 17:55:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B6C164F32
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Mar 2021 17:55:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B6C164F32
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20933-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13875 invoked by uid 550); 12 Mar 2021 17:55:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13840 invoked from network); 12 Mar 2021 17:55:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1615571687;
	bh=5zvDdlBOTpGmg8SYWvlilFo6X3L3cFtO5aKa0CwJZc4=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H2qPS5OMh+GAQjEPyXw7WHk3to0jYJ7sDl4tsYsXBZIWamCr2BW3Qrbg+JHG7GLpW
	 KzhLxagtJzjy1tyniaT4eP/Usxbgx9kB+XdCopLHZovz2yHUieSsG/4+p9nv1FV800
	 7A628qswk5DAsHm7U/eRWYrCcxiQIVEVoFFUzPj0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 12 Mar 2021 18:54:44 +0100
From: John Wood <john.wood@gmx.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: John Wood <john.wood@gmx.com>, Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>, Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 7/8] Documentation: Add documentation for the Brute LSM
Message-ID: <20210312175444.GC3103@ubuntu>
References: <20210227153013.6747-8-john.wood@gmx.com>
 <878s78dnrm.fsf@linux.intel.com>
 <20210302183032.GA3049@ubuntu>
 <20210307151920.GR472138@tassilo.jf.intel.com>
 <20210307164520.GA16296@ubuntu>
 <20210307172540.GS472138@tassilo.jf.intel.com>
 <20210307180541.GA17108@ubuntu>
 <20210307224927.GT472138@tassilo.jf.intel.com>
 <20210309184054.GA3058@ubuntu>
 <20210311200517.GG203350@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311200517.GG203350@tassilo.jf.intel.com>
X-Provags-ID: V03:K1:SuNaC8l4ofMz5PeVWxAj2Ub9Iy1nxdyzxd1L6V/gtgj5gnFLD1S
 I5L/bUQtKOVdCBxKBO/ZP7Ncca+0qE8R3yw3fhaopP1rEuS5z8BzijroK8maIG7T6YhP+NZ
 z1VOvu+civtZqHxFIQLRLgTi7vErnDtFx9VwG5ckyMVuHs2NwPNZn2Te+26cCuctNXPpOCW
 9tg918q9c3iomwA9F5b1A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2g/OjCOku7o=:a+cdNEVUGAIPK9zpYFpOP9
 TCWcVVVEzGCwEteqlEZcE7eWU/SLIKQHwRiNlS/duxRoTowXyMbY2AbfxUpp7lEImTUiF8WvC
 Ccxpi0oKPnIVJF7ZyexplRm5MsO0HGkA275ksMn92E23nIwzLA+bXIzwwX3CUL3dOBfitpIq+
 cwOhS3UxNcIo8I8oUo+y2KXmOMef/sYHlNKZyyp+oWLcv1T2aHGQJHGU11JEDEXeowj5d18H4
 mkGAuCOCCtCaeiHoaAqr8enyrjp/K3O95QROMvycy1hjBzVRm5dux5b7bDNOGfXN0rahVjamD
 lA4NSYsuwX0DhXIwKdobgJOJ6JwRsu9EJHx9m5iwGvlY+eBNRKgLsuNQ1etPpJqGBDIcLMf1b
 TLALI1YKZaEciWdYO+gUv59qBXbctxwUBfPxvO4MKNJWfm9etplamNUI/xCl1MVs0n1d434h4
 x+BslsfjnmmcFtfB83/3nusuqtL0sDmOkzmPps/53CJw2XZPa0c5Ig6GyvVR99bBxtb823jcR
 ULVMMpVE4ogc0OIPhOpFygvVTIeXQ2HeIh+G2a1ncuPaQLMj4LfwNTBsPRQx/YqKYV3xdKmAz
 KMjQwau3Hn30MVTMR9NUAiihKug/crLomVAW2oM4OWdsbPbP9NlBleIEVNBKXtMPu+EFuEY+k
 30SyxfjHNAk7HAeDi04qnrDt6Ph8NVmi0+lbq/OehAQeJ5OOKNa60YtzLVRQQxu7NXeid8Y/b
 HFIKdUCtfYW1cwDLiFHtHxtBQzKLxXZO0SJPgQG7vvCwcIEBx46/c6xhMC6snSlktztnS44OE
 MPyFUBi2P7FdyycZV+QxmZZB9SlbM1On+dXSO6/1Ltgp60vhRJozmQUyw2D92Izn4t9PafMja
 BvyOzBBZiOelJTgq7PSg==
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 11, 2021 at 12:05:17PM -0800, Andi Kleen wrote:
>
> Okay but that means that the brute force attack can just continue
> because the attacked daemon will be respawned?
>
> You need some way to stop the respawning, otherwise the
> mitigation doesn't work for daemons.
>
I will work on your solution regarding respawned daemons (use wait*() to i=
nform
userspace that the offending processes killed by the mitigation exited due=
 to
this mitigation -> then the supervisor can adopt their own policy).

>
> -Andi
>

Thank you very much,
John Wood
