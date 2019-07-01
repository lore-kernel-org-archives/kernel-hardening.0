Return-Path: <SRS0=KrOD=U6=lists.openwall.com=kernel-hardening-return-16333-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C38AC0650E
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:49:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 85556206A3
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Jul 2019 18:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PrAOKx/X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85556206A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16333-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21521 invoked by uid 550); 1 Jul 2019 18:49:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20479 invoked from network); 1 Jul 2019 18:49:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=onJe6dugm/eh3u5ymxkdFs06KErcIHwp+V9gxqC9i0c=;
        b=PrAOKx/XcNOBcohT0hQAfOyr30bYhmCFLavIdDXk20F/l4HIfEG5nj6+wOPs6WHxKl
         auXRCuByvA6ZVhAtYiUNdo5ZtB7KUMRyyDPSM+kJ2HQbwVrsJ4dLgXJ6XqO6usSNrkVV
         VVJuhf0NRNDRtmRPmff9BvJvoLQm9oWLBTtYNBMmFyssCzImCgW6BK+p1TVBiduf5N84
         5++uu7rRDYSIWdJhNJG3MRjgpEv4ShUTToGAN6j61yz4f2FBzp71mYAeRRuSh88jxhFT
         xemzoqYcvh2Aofqnn5/+mU7bYDZ/Q2VqzVdR2+t+Tj1p05Dz6z7Ed8hiidWdqsxk10T7
         94GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=onJe6dugm/eh3u5ymxkdFs06KErcIHwp+V9gxqC9i0c=;
        b=SppemHIvuZvZwa0mefTVVXsrLmydn+gwHCM5/ppZ8angh4gKYm+3pV39m92uJWm/o+
         3MvB1SuuCSs/7IY3yWqsPIeNVS3TXCwzVamFGTTfQBb5Q3Hq2CDyLK6cKYUgpltap37U
         8bWqqj1J95mGPye0yE7OsLE0lsDbAdtauBaUbS1+cWrluU6JHlWMWLjPgnpPZ14rJQqc
         K/jyZQ1IcK5Van904zEOE25blWqmzyHM/7h/V22qKBf4KopQsulzdiY0ydPfM5ivCMjF
         hDWj3YVKukH1Hwzg+/DzGO2lK7BWJ3d2q2y8W/Llh/zCAc2bMUemPlVxrq7BkHabC2x7
         K2oA==
X-Gm-Message-State: APjAAAVrbdPbyJyjxdmAS0EFSuqdiM3HZnRuCMMNZxP+3yv56TBi6ZZQ
	TVH4TG8FaBTpWEkwDWVZV/rz+lYxWVrEVNR1X5LEyg==
X-Google-Smtp-Source: APXvYqwWnCMIxXVuRreDvcVNzNNoZyG288LSyiQ+/bNv7cs2p9ghKPdfns5hkYEHWm5ctyKxNbbPoQjPnRM02dP/1I4=
X-Received: by 2002:a37:a10b:: with SMTP id k11mr20459116qke.76.1562006950089;
 Mon, 01 Jul 2019 11:49:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190628193442.94745-1-joel@joelfernandes.org> <201907020214.bB70pmmk%lkp@intel.com>
In-Reply-To: <201907020214.bB70pmmk%lkp@intel.com>
From: Joel Fernandes <joelaf@google.com>
Date: Mon, 1 Jul 2019 14:48:58 -0400
Message-ID: <CAJWu+oqGC5oDqyRVUxYZ-XN4qJPaaUNbPqa5hapox4m9=17iSw@mail.gmail.com>
Subject: Re: [PATCH v2] Convert struct pid count to refcount_t
To: kbuild test robot <lkp@intel.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, kbuild-all@01.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, 
	Paul McKenney <paulmck@linux.vnet.ibm.com>, elena.reshetova@intel.com, 
	Kees Cook <keescook@chromium.org>, "Cc: Android Kernel" <kernel-team@android.com>, 
	kernel-hardening@lists.openwall.com, 
	Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 1, 2019 at 2:47 PM kbuild test robot <lkp@intel.com> wrote:
>
> Hi "Joel,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on linus/master]
> [also build test WARNING on v5.2-rc6]
> [cannot apply to next-20190625]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

Jann H was faster than the robot in catching this, so humanity still has hope!

Its fixed in v3.
