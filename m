Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: markus@google.com
In-Reply-To: <CABqD9haZpe-i8kyHJDj4umCLyZ3E877aobabvW8_+aXeC+kTbg@mail.gmail.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
 <1330140111-17201-6-git-send-email-wad@chromium.org> <b983ece9dc6209269876869188303518.squirrel@webmail.greenhost.nl>
 <CABqD9haZpe-i8kyHJDj4umCLyZ3E877aobabvW8_+aXeC+kTbg@mail.gmail.com>
From: Markus Gutschke <markus@chromium.org>
Date: Tue, 28 Feb 2012 09:47:59 -0800
Message-ID: <CAE6n16kLOOrAV6_7_t_-PnfYoNsJ5yJfHveWykO7qQiFYKb3nQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v11 06/12] seccomp: add system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: Indan Zupancic <indan@nul.nu>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2012 at 09:17, Will Drewry <wad@chromium.org> wrote:
> On Tue, Feb 28, 2012 at 12:51 AM, Indan Zupancic <indan@nul.nu> wrote:
>> Wouldn't it make more sense to always kill with SIGSYS, also for mode 1?
>> I suppose it's too late for that now.
>
> It would but I don't want to go and change existing ABI.

Just for the record, when this discussion came up about two years ago,
it was established that other than Chrome, there are currently no
users of Seccomp, as mode 1 is just too difficult to use for most
potential applications.

Chrome doesn't rely on the exit status of a process that violated the
seccomp restrictions, so it is highly unlikely you would break
existing userspace, if you changed the ABI. On the other hand, as mode
2 is so much more powerful than mode 1, it is unlikely that we will
see future userspace applications make use of mode 1.

In other words, changing the ABI is unlikely to cause harm, but also
unlikely to do any good. I don't have any strong opinion either way;
just providing an additional data point.


Markus
