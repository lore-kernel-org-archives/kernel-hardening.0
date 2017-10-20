Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0ad1f8b1-3c9f-adb0-35c3-18619ff5aa25@redhat.com>
Date: Sat, 21 Oct 2017 00:40:25 +0200
MIME-Version: 1.0
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 00/23] Hardened usercopy whitelisting
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 20/06/2017 01:36, Kees Cook wrote:
> 
> This updates the slab allocator to add annotations (useroffset and
> usersize) to define allowed usercopy regions. Currently, hardened
> usercopy performs dynamic bounds checking on whole slab cache objects.
> This is good, but still leaves a lot of kernel slab memory available to
> be copied to/from userspace in the face of bugs. To further restrict
> what memory is available for copying, this creates a way to whitelist
> specific areas of a given slab cache object for copying to/from userspace,
> allowing much finer granularity of access control. Slab caches that are
> never exposed to userspace can declare no whitelist for their objects,
> thereby keeping them unavailable to userspace via dynamic copy operations.
> (Note, an implicit form of whitelisting is the use of constant sizes
> in usercopy operations and get_user()/put_user(); these bypass hardened
> usercopy checks since these sizes cannot change at runtime.)

This breaks KVM completely on x86, due to two ioctls
(KVM_GET/SET_CPUID2) accessing the cpuid_entries field of struct
kvm_vcpu_arch.

There's also another broken ioctl, KVM_XEN_HVM_CONFIG, but it is
obsolete and not a big deal at all.

I can post some patches, but probably not until the beginning of
November due to travelling.  Please do not send this too close to the
beginning of the merge window.

Paolo
