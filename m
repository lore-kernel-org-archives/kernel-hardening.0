Subject: Re: [PATCH] drm/i2c: tda998x: Remove VLA usage
References: <20180409210703.3787-1-labbott@redhat.com>
 <20180409222141.GR16141@n2100.armlinux.org.uk>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <855433a0-72f5-df29-3a17-5c2016e988e1@redhat.com>
Date: Tue, 10 Apr 2018 14:52:35 -0700
MIME-Version: 1.0
In-Reply-To: <20180409222141.GR16141@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/09/2018 03:21 PM, Russell King - ARM Linux wrote:
> On Mon, Apr 09, 2018 at 02:07:03PM -0700, Laura Abbott wrote:
>> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
>> turn on -Wvla. The vla in reg_write_range is based on the length of data
>> passed. The one use of a non-constant size for this range is bounded by
>> the size buffer passed to hdmi_infoframe_pack which is a fixed size.
>> Switch to this upper bound.
> 
> Does this _really_ make it safer?  What if the code is modified to write
> more than 32 bytes in the future?
> 
> Sorry, I don't think this is safer at all.
> 

Yeah I wasn't 100% sure about this one. Elsewhere, we've added bounds
checks against the new static size buffer so we could do that here
to ensure we don't overrun the stack if we do need to write more
than 32 bytes in the future. Another option is to switch to
a kmalloc buffer. Are either of those options acceptable to you or
do you have a better idea of how to get rid of the VLA?

Thanks,
Laura
