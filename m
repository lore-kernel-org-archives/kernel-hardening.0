Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
 <0ad1f8b1-3c9f-adb0-35c3-18619ff5aa25@redhat.com>
Message-ID: <0015a75a-3624-2ec7-ae21-4753cf072e61@redhat.com>
Date: Sat, 21 Oct 2017 01:25:55 +0200
MIME-Version: 1.0
In-Reply-To: <0ad1f8b1-3c9f-adb0-35c3-18619ff5aa25@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 00/23] Hardened usercopy whitelisting
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 21/10/2017 00:40, Paolo Bonzini wrote:
> This breaks KVM completely on x86, due to two ioctls
> (KVM_GET/SET_CPUID2) accessing the cpuid_entries field of struct
> kvm_vcpu_arch.
> 
> There's also another broken ioctl, KVM_XEN_HVM_CONFIG, but it is
> obsolete and not a big deal at all.
> 
> I can post some patches, but probably not until the beginning of
> November due to travelling.  Please do not send this too close to the
> beginning of the merge window.

Sleeping is overrated, sending patches now...

Paolo
