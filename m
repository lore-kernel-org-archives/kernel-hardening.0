Return-Path: <kernel-hardening-return-21591-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 51E26C4321E
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Dec 2022 21:35:30 +0000 (UTC)
Received: (qmail 18362 invoked by uid 550); 1 Dec 2022 21:35:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8163 invoked from network); 1 Dec 2022 21:14:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669929285; x=1701465285;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rGV9/sGB5NA5ei2xfzI/Xf9HZin/s7i+I+92rYOoLQE=;
  b=WkFw5n9AJZNiwmLjceu9TCFmXns2JSql8RGJLaQ8aundw/wGFyXkTZr2
   KAnw7EXvqP2ogSs+DGT+KRoC6VpzunxxCuqyQr2bsJJMmHcdZa1ejVDxI
   Tb2VjBoG0JbmF5tIqaQ/qowZyDj0ubLRMqm8xhWhvlJkpAci4cUPutIWA
   JdMxjizyJ8Pga0risYcSX4E8dVB7vd7KjDKxGcb6kgyPh1SYXLzEmNCRL
   eU+beLvmFGsGlGUZNoV4YA3k0TN0GCrR5yZ7bxOEigXAOmgmRfxdM+vmg
   YHMU8TGMO4nH9xWdRdb3v/h+XykG6EufbK7fm3/emTsn2/qEB4BcfqhTO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="342733210"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="asc'?scan'208";a="342733210"
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="646913065"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="asc'?scan'208";a="646913065"
Date: Thu, 1 Dec 2022 13:14:29 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Reducing runtime complexity
Message-ID: <20221201211429.venqtlzegdbdc7et@desk>
References: <Y4kJ4Hw0DVfy7S37@mailbox.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vl2okk3xc343pg2o"
Content-Disposition: inline
In-Reply-To: <Y4kJ4Hw0DVfy7S37@mailbox.org>


--vl2okk3xc343pg2o
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Thu, Dec 01, 2022 at 09:09:04PM +0100, Stefan Bavendiek wrote:
>Some time ago I wrote a thesis about complexity in the Linux kernel and
>how to reduce it in order to limit the attack surface[1]. While the
>results are unlikely to bring news to the audience here, it did
>indicate some possible ways to avoid exposing optional kernel features
>when they are not needed. The basic idea would be to either build or
>configure parts of the kernel after or during the installation on a
>specific host. Distributions are commonly shipping the kernel as one
>large binary that includes support for nearly every hardware driver and
>optional feature

Is this really true? Most drivers are built as loadable modules and are
only loaded when the hardware is present.

Are you suggesting to configure-out the modules that are always static?
This sounds like an embedded system build.

--vl2okk3xc343pg2o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEhLB5DdoLvdxF3TZu/KkigcHMTKMFAmOJGTUACgkQ/KkigcHM
TKO8Hg/7BtJQa0gxh2s6wp8eQu0bVFa6vPEf4jHnO27WARZRidGnlg9WzOqxF4Pq
BTrdHlRsmrNbW0dl2T2ke2s5bs5YBIb1j/6nAVEiHy58yS89r80AXxIrPuQU6h/u
IeebBtst8mvgj/cOUnguiE191ZmBizyGcgiRDVHTXFOFWBhNBe3dmSUNefgiUpr0
BWKticd6Dm0EeKyOE3xR+gvsdz9kbmw2nE6KXpdwnjcu0VH7tMJx4v/jmzb+EUV4
i/c9p3DmPR6HSBQM3OzMozFt55ttlw+P9R14PHt2oNJWNbgVvdkr8kq6Am4QUn0M
q7QyD6nennNS2Gq5NsOlF6CR3xt1YLGZJjglpOuGGLwF0kNO1JTjlVKdKe3AjkjB
9KS+QVLIcm/KaT8wJaTKZc+AvlHQBRaXgY+X6IwLAPDHkISEqRHjESmDhI4KYSLo
qEhLbVBu+2dnSbn7PAF3dIbqP9Sa3y6ioieRBjBZW6if2IkNHwSxfV1pq6WtkvQ6
3pGbCVu1Ah4LWIqRbfXFkX6VEt9V+A4kiytqNXnBdodZjCeOTNIr6rmbRMH18Z8d
F/4xyh7kNqrbFn68K0mMloR3Oc0eWzdcTtBXjwoNyJ2nuq6i3CEYx+d5QBijCUgf
GDENGYW15VujEs5jfdN+UDdv8xpJFJECs1pdf+WQfKMpyyM+J1I=
=NnWb
-----END PGP SIGNATURE-----

--vl2okk3xc343pg2o--
