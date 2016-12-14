Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161214192459.GA16972@leverpostej>
References: <20161214185000.GA3930@kroah.com> <20161214192459.GA16972@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 14 Dec 2016 12:16:56 -0800
Message-ID: <CAGXu5j+z22GzJYkejrDW2tiT-rZPOp4h-VnoN8gVLBrEmt7Zkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC 0/4] make call_usermodehelper a bit more "safe"
To: Mark Rutland <mark.rutland@arm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Gengjia Chen <chengjia4574@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 14, 2016 at 11:25 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>
> Hi,
>
> On Wed, Dec 14, 2016 at 10:50:00AM -0800, Greg KH wrote:
>> The issue is that if you end up getting write access to kernel memory,
>> if you change the string '/sbin/hotplug' to point to
>> '/home/hacked/my_binary', then the next uevent that the system makes
>> will call this binary instead of the "trusted" one.
>>
>> It does this by moving the location of the binary to be in read-only
>> memory.  This works for a number of call_usermodehelper strings, as they
>> are specified at build or configuration time.  But, some subsystems have
>> the option to let userspace change the value at runtime, so those values
>> can't live in read-only memory.
>
>> So, anyone have any better ideas?  Is this approach worth it?  Or should
>> we just go down the "whitelist" path?
>
> As a general note, I believe the write-rarely / mostly-ro [1] stuff is
> meant to cater for this case, but I haven't heard anything on that front
> recently (and there doesn't appear to be anything on the KSPP TODO
> page).

Using write-rarely on sysctls makes sense, though I remain concerned
about userspace bugs where root gets tricked into writing a bad value
into a sysctl (which write-rarely wouldn't be able to help). A CONFIG
here seems okay without the write-rarely infrastructure, though I
wonder if a write-once runtime value would be better? Something like
modules_disabled where once flipped, the sysctls become read-only?

> If that does cater for this case, and if we're able to implement that
> generically, that might be nicer than locking down the set of binaries
> at build time.
>
> Chen, are you still looking at implementing write-rarely support?
>
> Thanks,
> Mark.
>
> [1] http://www.openwall.com/lists/kernel-hardening/2016/11/16/3

Even if it's "wrong", I'd love to see an actual RFC for the
write-rarely. In the face of a "wrong" patch, we can at least more
forward with alternative ideas...

-Kees

-- 
Kees Cook
Nexus Security
