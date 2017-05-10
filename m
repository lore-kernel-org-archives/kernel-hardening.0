Message-ID: <1494441091.4602.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 10 May 2017 14:31:31 -0400
In-Reply-To: <1494439172.1255.1.camel@gmail.com>
References: <20170510173637.25116-1-danielmicay@gmail.com>
	 <20170510175238.GH32165@htj.duckdns.org>
	 <1494439172.1255.1.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] mark most percpu globals as __ro_after_init
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> Booted / did some stuff on x86 (it's running right now), and currently
> building it for a 3.18 arm64 kernel to test there.

Yeah, confirmed to work on an Android 3.18 arm64 kernel (Pixel phone)
too in addition to 4.11 and master for x86_64.
