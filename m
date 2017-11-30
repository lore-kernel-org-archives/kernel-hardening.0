MIME-Version: 1.0
In-Reply-To: <20171130141636.k3oqybwosdogzfgg@thunk.org>
References: <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
 <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com>
 <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com>
 <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com>
 <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com>
 <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com>
 <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com>
 <1512024677.1374.168.camel@gmail.com> <CAEiveUdgm_n-TUYGCtw_Zf24TJXrdrsFjcU8_S1M2qQUmHG+KA@mail.gmail.com>
 <20171130141636.k3oqybwosdogzfgg@thunk.org>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu, 30 Nov 2017 15:51:28 +0100
Message-ID: <CAEiveUcqVpV0592caA2wGRcvf6aWGX4XSAx+PLrh53VbAK=rYw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Theodore Ts'o <tytso@mit.edu>, Djalal Harouni <tixxdz@gmail.com>, Daniel Micay <danielmicay@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 30, 2017 at 3:16 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Nov 30, 2017 at 09:50:27AM +0100, Djalal Harouni wrote:
>> In embedded systems we can't maintain a SELinux policy, distro man
>> power hardly manage. We have abstracted seccomp etc, but the kernel
>> inherited the difficult multiplex things, plus all other paths that
>> trigger this.....
>
>> Yes, but it is hard to maintain a whitelist policy, the code is hardly
>> maintained...
>
> So this is the part that scares me to death about IOT, and why I tell
> everyone to ***never*** trust an IOT device on their home network, and
> ***never*** trust it with anything you don't mind splattered all over
> the front page of NY Times and RT / Sputnick news.

Yes.

For your pleasure:
https://techcrunch.com/2017/04/25/brickerbot-is-a-vigilante-worm-that-destroys-insecure-iot-devices/
 bricked million of devices to stupid busybox remote port.
https://en.wikipedia.org/wiki/Mirai_(malware)  an other million bots
used to disturb netflix, twitter and others I don't know the details.
...

> You're saying that you want to use modules (as opposed to compile
> everything tightly down to just what you need for the embedded
> system); that the code is "hardly maintained".  And yet we're supposed
> to consider it trustworthy?

I didn't say that.

> If that's the case, turning off implicit module loading sounds and
> thinking that this will somehow be a magic wand sounds.... crazy.

The product costs decide, web developers, javascript, big data
analysis, electronic engineers all want to use Linux for IoT prototype
and sell in some months, they will get any kernel+userspace add their
value on top and sell. It will be non-sense to think that if a web
developer wants to sell a node.js app as an IoT he has to compile a
kernel and do all the other stuff, they all re-use the same layer the
same config for everything. Requiring for everyone to compile its own
kernel does not make much sense. Default safe behaviour is what we
should do.

Thanks!

>                                      - Ted



-- 
tixxdz
