Return-Path: <SRS0=bF4l=JG=lists.openwall.com=kernel-hardening-return-21190-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744A5C433B4
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 23:28:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 47649610CA
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 23:28:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47649610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=vt.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21190-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26207 invoked by uid 550); 9 Apr 2021 23:28:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26163 invoked from network); 9 Apr 2021 23:28:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:in-reply-to:references:mime-version
         :content-transfer-encoding:date:message-id;
        bh=8X4qcfXiEyb8Od+TR2/ADrVsCC9azYx1TTWvNHRlFTg=;
        b=IyqNeNfeeDuH4wlofp482M8Vs4VSJ94cRBvGsquc82ueJGPjpPcA2N9hEABevPXEWZ
         +vZ43DOSeJpAiPOLhrQ0xatctmXfkAtz2XSrPbNJMCbQHNwVGTmVXFkLdWXu2sacfmBr
         n/eBURMZHIOkUFxIu/kO66qy6DB7tQ1QZ5M4QfW6j2IerOLV6ILKR2AOiiwa0rpNdhus
         +s+jRRwe4MyzS6JVOA9r4Cbx6juVmXDi4j97dN1cNYlAjNxXNO3Z0qte1bfUsU6rQC8X
         BwRdWRD0cdngeNWHITpCcmALZ2jU+UcVNsEdvlGopRoFY7aEhSNtzkvWW0y/DI+txrBL
         gdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=8X4qcfXiEyb8Od+TR2/ADrVsCC9azYx1TTWvNHRlFTg=;
        b=PsbaMP3hYBy7xtLSYxYvfv+2Uq0rLmUpPPHFsddDg955/vtOxsE+C12B4MYJgckuZr
         TAcdzNjuHKECw5d7o/fAq6ISei+yYJ1m9FpUxPtVmg/Q3aRlwvfok9uftynXwGEV1yRu
         T0Xa0TM1y3XOcD/5A3gHrtHparUf9AhrnRp6903dALIYV/MfHWiOem6Rpx8JSPc2xoY3
         nLo5JA75H88iSNiYn7lB1f3NECTiuZUnpVhg8vGkpvOKYgjcOoRpQYQqhR31lfE7nhGO
         uwxOIE4KNpAKegPxJc5vY1eBVEWbT5Kepsbccbc/IkH1O9WXJPTzBFc6iFxhuF0TDPPF
         /Zhw==
X-Gm-Message-State: AOAM5320RSfLfsg8gS/zQq152sN65e7dUdfdf1GhgpJvI7Xu0SjWXDXF
	sBbU8HQ+AiPf2PqDBj/Mv0MZBQ==
X-Google-Smtp-Source: ABdhPJzT5HjzTsJ8VR4VLidzKcPEBibPtlSR5Ub7k4FF+xysXg9oo7m7My399Qzv9rjvSumvfosXow==
X-Received: by 2002:a37:41ca:: with SMTP id o193mr16860439qka.56.1618010902151;
        Fri, 09 Apr 2021 16:28:22 -0700 (PDT)
Sender: Valdis Kletnieks <valdis@vt.edu>
From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To: Andi Kleen <ak@linux.intel.com>
Cc: John Wood <john.wood@gmx.com>, kernelnewbies@kernelnewbies.org,
    Kees Cook <keescook@chromium.org>,
    kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
In-Reply-To: <20210409150621.GJ3762101@tassilo.jf.intel.com>
References: <20210403070226.GA3002@ubuntu> <145687.1617485641@turing-police> <20210404094837.GA3263@ubuntu> <193167.1617570625@turing-police> <20210405073147.GA3053@ubuntu> <115437.1617753336@turing-police> <20210407175151.GA3301@ubuntu> <184666.1617827926@turing-police> <20210408015148.GB3762101@tassilo.jf.intel.com> <20210409142933.GA3150@ubuntu>
 <20210409150621.GJ3762101@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1618010900_95215P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 09 Apr 2021 19:28:20 -0400
Message-ID: <109781.1618010900@turing-police>

--==_Exmh_1618010900_95215P
Content-Type: text/plain; charset=us-ascii

On Fri, 09 Apr 2021 08:06:21 -0700, Andi Kleen said:

> Thinking more about it what I wrote above wasn't quite right. The cache
> would only need to be as big as the number of attackable services/suid
> binaries. Presumably on many production systems that's rather small,
> so a cache (which wouldn't actually be a cache, but a complete database)
> might actually work.

You also need to consider non-suid things called by suid things that don't
sanitize input sufficiently before invocation...

Thinking about at - is it really a good thing to try to do this in kernelspace?
Or is 'echo 1 > /proc/sys/kernel/print-fatal-signals' and a program to watch
the dmesg and take action more appropriate?  A userspace monitor would
have more options (though a slightly higher risk of race conditions).


--==_Exmh_1618010900_95215P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBYHDjEwdmEQWDXROgAQIjYA/9H314PauR3vcLGuhB5j8IlyAFuQL17Ej1
GU01f0+EsyMznqiNSnA8ZBM9LKAfZlc4/qtINqAWzWePT9vHzic4cblATfVQv+W4
1JnXYtZ66dT51VbJ5hlPDL/C4Y/GkPMdNtmUFsOSu2XCUHT8dTMGdvgn6OmFUHtZ
q4ZnT38Rr04zkUOLAOR+NP+xK/sEcRYdMkmEc0qZBfwFHJBzatC8JcdhhtGrIZu9
mh6PX3K74GWMeGb0xDHFTEnhRa2AEnaWSGXy9ZMyXAnuQPyXb0iecfc3R/xkEofI
W32+d8RGaX9TlE0QFA5dzl/8lU5A+vorLfZjMfqV/U5hGQvnsIzASAURehR+1dEE
pMLyohVb9sMevTbA/Df88vQAHKif76Rg9Q3FMT4L1/DstlgN1ywR6sZgxOmR3BAO
dxtAdG0SX/sHHIpWlp00N7n1wY9OO88SCHmoFjYgtsvT13GRwRWdIpfkh6j9ctQK
jm+VP2+waHih9ur2YxxAOv3kSMC4seetV0Xvs0cfOKr3MDp3kNVjLv6qHK71sjiH
zN2goPtFDEbMtAWBG9aT6X46HL0R5x2d+RmSwQxNpMzKLpqiQDzRJgeOfMVAALY6
nlbmEujM2vMFv7uefXefSWqswqacCw+z728kBfa6ythZkSQ11zwhJS/OrxyLxTg7
cst3qofMPvU=
=y9hs
-----END PGP SIGNATURE-----

--==_Exmh_1618010900_95215P--
