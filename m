Subject: Re: [PATCH] x86/xen: Remove use of VLAs
References: <20180413221146.28476-1-labbott@redhat.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <49e13c53-718f-879c-fc0d-b0f5dd7ea23d@suse.com>
Date: Mon, 16 Apr 2018 10:11:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180413221146.28476-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 14/04/18 00:11, Laura Abbott wrote:
> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> turn on -Wvla. The few VLAs in use have an upper bound based on a size
> of 64K. This doesn't produce an excessively large stack so just switch
> the upper bound.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
