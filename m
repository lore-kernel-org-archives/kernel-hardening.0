References: <20171026134547.23664-1-pbonzini@redhat.com>
 <20171026134547.23664-3-pbonzini@redhat.com>
 <CAGXu5jKzA8UfV9Bfiz=1ZvHLjM+DYDiifR7e=EG956qNrS20JQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e4b845bc-cc20-67f5-c188-334b48a11af9@redhat.com>
Date: Fri, 1 Dec 2017 09:29:35 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKzA8UfV9Bfiz=1ZvHLjM+DYDiifR7e=EG956qNrS20JQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/2] kvm: x86: fix KVM_XEN_HVM_CONFIG ioctl
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>, kernel-hardening@lists.openwall.com, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 30/11/2017 21:40, Kees Cook wrote:
> Hi Paolo,
> 
> Since this didn't make it via my usercopy tree, do you want to take it
> via KVM? It is a stand-alone fix, AIUI.

Yes, will do!  Thanks,

Paolo
