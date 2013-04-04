Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <515DE24D.3080507@zytor.com>
Date: Thu, 04 Apr 2013 13:27:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DDEC0.9000109@zytor.com> <CAKyRK=iZeYv8MPa2tLfRRTmNX2WQsT+t3UAu_wy3uT9TiZokgA@mail.gmail.com> <CAKyRK=ic3QHOLKen=jxgeEN5mVVj_Gyt-1wXOniKNgO75f80Qw@mail.gmail.com>
In-Reply-To: <CAKyRK=ic3QHOLKen=jxgeEN5mVVj_Gyt-1wXOniKNgO75f80Qw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Julien Tinnes <jln@google.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/04/2013 01:23 PM, Julien Tinnes wrote:
> On Thu, Apr 4, 2013 at 1:19 PM, Julien Tinnes <jln@google.com> wrote:
>> On Thu, Apr 4, 2013 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 04/04/2013 01:07 PM, Kees Cook wrote:
>>>> However, the benefits of
>>>> this feature in certain environments exceed the perceived weaknesses[2].
>>>
>>> Could you clarify?
>>
>> I think privilege reduction in general, and sandboxing in particular,
>> can make KASLR even more useful. A lot of the information leaks can be
>> mitigated in the same way as attack surface and vulnerabilities can be
>> mitigated.
> 
> Case in point:
> - leaks of 64 bits kernel values to userland in compatibility
> sub-mode. Sandboxing by using seccomp-bpf can restrict a process to
> the 64-bit mode API.
> - restricting access to the syslog() system call
> 

That doesn't really speak to the value proposition.  My concern is that
we're going to spend a lot of time chasing/plugging infoleaks instead of
tackling bigger problems.

8 bits of entropy is not a lot.

	-hpa
