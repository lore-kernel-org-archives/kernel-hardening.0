Date: Thu, 12 Apr 2018 21:48:04 -0400 (EDT)
Message-Id: <20180412.214804.685830742109478351.davem@davemloft.net>
Subject: Re: [PATCHv2] mISDN: Remove VLAs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180411010429.18074-1-labbott@redhat.com>
References: <20180411010429.18074-1-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: labbott@redhat.com
Cc: isdn@linux-pingi.de, keescook@chromium.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Laura Abbott <labbott@redhat.com>
Date: Tue, 10 Apr 2018 18:04:29 -0700

> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> turn on -Wvla. Remove the VLAs from the mISDN code by switching to using
> kstrdup in one place and using an upper bound in another.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v2: Switch to a tighter upper bound so we are allocating a more
> reasonable amount on the stack (300). This is based on previous checks
> against this value.

Applied.
