MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jJXqY=KGHtrCQ3yLGVFd7K6Akk6B8VbWyZHGfRerYeV0A@mail.gmail.com>
References: <CANEHqc0zV9Ppj3Ny2GrV=f2grA5XiPOtxEmkZ9XaMxJmDvk-tw@mail.gmail.com>
 <CAGXu5jJXqY=KGHtrCQ3yLGVFd7K6Akk6B8VbWyZHGfRerYeV0A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 10 Feb 2017 15:31:11 -0800
Message-ID: <CAGXu5jJ3wwpuf_WwA9JJ1up1RLMmJRcZrSW1CAVkwMUrTtmJ+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction + new project: "rootkit detection
 using virtualization".
To: Matthew Giassa <matthew@giassa.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM <kvm@vger.kernel.org>, Matthew Garrett <matthewgarrett@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2017 at 3:27 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Feb 10, 2017 at 2:00 PM, Matthew Giassa <matthew@giassa.net> wrote:
>> Good day,
>>
>> I am a volunteer developer taking up a project originally proposed by
>> Rik van Riel, "rootkit detection using virtualization", and am
>> planning to contribute regularly to this project over the coming
>> months. I was advised to contact these mailing lists to introduce
>> myself, and I also wanted to inquire about any existing projects that
>> coincide with this work. My initial work will involved diving into KVM
>> + qemu source and deciding how best to approach the problem. While I
>> have the attention of list members, are there any specific
>> individuals/groups I should contact directly with respect to this type
>> of project?
>>
>> Thank you.
>
> Hi! Welcome to the list(s)!
>
> I think this is an interesting area of research, though it may be a
> tricky cat/mouse game. Some of this kind of
> hypervisor-protects-the-kernel work has been done on some Android
> phones in small areas (see the cred protection near the end):
>
> http://keenlab.tencent.com/en/2016/06/01/Emerging-Defense-in-Android-Kernel/

And some privilege monitoring work done by Matthew Garrett:

https://github.com/mjg59/rkt/commits/privilege

-Kees

-- 
Kees Cook
Pixel Security
