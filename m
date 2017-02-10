MIME-Version: 1.0
In-Reply-To: <87efzag2fs.fsf@concordia.ellerman.id.au>
References: <1486098682-30395-1-git-send-email-bhsharma@redhat.com> <87efzag2fs.fsf@concordia.ellerman.id.au>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Fri, 10 Feb 2017 13:15:13 +0530
Message-ID: <CACi5LpOD5VCCmn4CdTZy+MA=4w9Vw+jiB7C435OfLCJ7_mW69Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v2 1/1] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, Daniel Cashman <dcashman@google.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Graf <agraf@suse.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>, Alistair Popple <alistair@popple.id.au>, Matt Porter <mporter@kernel.crashing.org>, Vitaly Bordug <vitb@kernel.crashing.org>, Scott Wood <oss@buserror.net>, Kumar Gala <galak@kernel.crashing.org>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Michael,

On Tue, Feb 7, 2017 at 7:57 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Bhupesh Sharma <bhsharma@redhat.com> writes:
>
>> powerpc: arch_mmap_rnd() uses hard-coded values, (23-PAGE_SHIFT) for
>> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
>> for the mmap base address.
>>
>> This value represents a compromise between increased
>> ASLR effectiveness and avoiding address-space fragmentation.
>> Replace it with a Kconfig option, which is sensibly bounded, so that
>> platform developers may choose where to place this compromise.
>> Keep default values as new minimums.
>>
>> This patch makes sure that now powerpc mmap arch_mmap_rnd() approach
>> is similar to other ARCHs like x86, arm64 and arm.
>>
>> Cc: Alexander Graf <agraf@suse.com>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Anatolij Gustschin <agust@denx.de>
>> Cc: Alistair Popple <alistair@popple.id.au>
>> Cc: Matt Porter <mporter@kernel.crashing.org>
>> Cc: Vitaly Bordug <vitb@kernel.crashing.org>
>> Cc: Scott Wood <oss@buserror.net>
>> Cc: Kumar Gala <galak@kernel.crashing.org>
>> Cc: Daniel Cashman <dcashman@android.com>
>> Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
>> Reviewed-by: Kees Cook <keescook at chromium.org>
>> ---
>> Changes since v1:
>> v1 can be seen here (https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-February/153594.html)
>>     - No functional change in this patch.
>>     - Added R-B from Kees.
>>     - Dropped PATCH 2/2 from v1 as recommended by Kees Cook.
>
> Thanks for v2.
>
> But I replied to your v1 with some comments, did you see them?
>

I have replied to your comments on the original thread.
Please share your views and if possible share your test results on the
PPC setups you might have at your end.

Thanks,
Bhupesh
