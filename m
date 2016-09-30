Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 30 Sep 2016 01:48:53 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160930004852.GC4369@remoulade>
References: <20160929213257.30505-1-labbott@redhat.com>
 <20160929213257.30505-2-labbott@redhat.com>
 <20160930001339.GA4369@remoulade>
 <e17189c7-54e0-f0a1-2b16-36f486111c4c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e17189c7-54e0-f0a1-2b16-36f486111c4c@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 1/3] arm64: dump: Make ptdump debugfs a separate option
To: Laura Abbott <labbott@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 29, 2016 at 05:31:09PM -0700, Laura Abbott wrote:
> On 09/29/2016 05:13 PM, Mark Rutland wrote:
> >On Thu, Sep 29, 2016 at 02:32:55PM -0700, Laura Abbott wrote:
> >>+int ptdump_register(struct ptdump_info *info, const char *name)
> >>+{
> >>+	ptdump_initialize(info);
> >>+	return ptdump_debugfs_create(info, name);
> >> }
> >
> >It feels like a layering violation to have the core ptdump code call the
> >debugfs ptdump code. Is there some reason this has to live here?
> 
> Which 'this' are you referring to here? Are you suggesting moving
> the ptdump_register elsewhere or moving the debugfs create elsewhere?

Sorry, I should have worded that better.

I meant moving ptdump_register into ptdump_debugfs.c, perhaps renamed to make it
clear it's debugfs-specific.

We could instead update existing users to call ptdump_debugfs_create()
directly, and have that call ptdump_initialize(), which could itself become a
staic inline in a header.

Thanks,
Mark.
