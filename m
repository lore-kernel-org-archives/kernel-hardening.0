MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jLcpfyq0TrXcmkzzO4oFzX0cERVtPFxoAtRyD-HxnAJyg@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <708003731.69563.1511905898471@ichabod.co-bxl> <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
 <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com>
 <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com>
 <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com>
 <CA+55aFxiDKfe6VCM+aV2OgnkzMpP+iz+rn2k25_Qa_QLex=pPQ@mail.gmail.com>
 <CAGXu5jJQnokKL2MdbQgOhBJ_RMHVvsw4u27Ds=4Jq3Ys=mjtRg@mail.gmail.com>
 <CA+55aFzi3Qj7zOrriRvrX5F4QDWMhkNQ7Qh-0FSCZsG4qk61zg@mail.gmail.com> <CAGXu5jLcpfyq0TrXcmkzzO4oFzX0cERVtPFxoAtRyD-HxnAJyg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Nov 2017 18:08:34 -0800
Message-ID: <CA+55aFxWKKjpqHL9pq=4r8ZMjvDSzzwHK69FFg+Re4CfAAtmqA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Kees Cook <keescook@chromium.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Jessica Yu <jeyu@kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 4:44 PM, Kees Cook <keescook@chromium.org> wrote:
>
>> That mainly leaves the protocol ones we need to look out for, I suspect.
>
> This is where a lot of the exposure really comes from. socket()
> triggers a bunch of stuff, but doesn't have an obvious privilege
> associated with it... while it already does the name templates, maybe
> add request_module_socket() just to explicitly mark it?

.. and this is where I'd expect that maybe we'd need some hackery.

Even including some ad-hoc rules like "this module is actually
maintained", possibly even with some /sys interface to extend/reduce
that set.

But maybe it's not even that bad.

                Linus
