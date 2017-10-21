MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <0015a75a-3624-2ec7-ae21-4753cf072e61@redhat.com>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
 <0ad1f8b1-3c9f-adb0-35c3-18619ff5aa25@redhat.com> <0015a75a-3624-2ec7-ae21-4753cf072e61@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 20 Oct 2017 20:04:11 -0700
Message-ID: <CAGXu5jKtNqnDA_vU5KaPuVJNCK0hBMGgYh6Ut0BVHvpu315XnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 00/23] Hardened usercopy whitelisting
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dave@nullcore.net>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 20, 2017 at 4:25 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 21/10/2017 00:40, Paolo Bonzini wrote:
>> This breaks KVM completely on x86, due to two ioctls
>> (KVM_GET/SET_CPUID2) accessing the cpuid_entries field of struct
>> kvm_vcpu_arch.
>>
>> There's also another broken ioctl, KVM_XEN_HVM_CONFIG, but it is
>> obsolete and not a big deal at all.
>>
>> I can post some patches, but probably not until the beginning of
>> November due to travelling.  Please do not send this too close to the
>> beginning of the merge window.
>
> Sleeping is overrated, sending patches now...

Oh awesome, thank you very much for tracking this down and building fixes!

I'll insert these into the usercopy whitelisting series, and see if I
can find any similar cases.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
