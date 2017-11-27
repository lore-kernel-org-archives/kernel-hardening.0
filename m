MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1511803118-2552-6-git-send-email-tixxdz@gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com> <1511803118-2552-6-git-send-email-tixxdz@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Nov 2017 10:44:21 -0800
Message-ID: <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use request_module_cap() to
 load 'netdev-%s' modules
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 9:18 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> This uses the new request_module_cap() facility to directly propagate
> CAP_NET_ADMIN capability and the 'netdev' module prefix to the
> capability subsystem as it was suggested.

This is the kind of complexity that I wonder if it's worth it at all.

Nobody sane actually uses those stupid capability bits. Have you ever
actually seen it used in real life?

They were a mistake, and we should never have done them - another case
of security people who think that complexity == security, when in
reality nobody actually wants the complexity or is willing to set it
up and manage it.

                   Linus
