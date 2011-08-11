Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110811171812.GA17346@albatros>
References: <20110808150204.GA4252@albatros> <20110809121632.18aef937@notabene.brown>
 <20110811171812.GA17346@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Aug 2011 11:27:39 -0700
Message-ID: <CA+55aFwJtyzcEksV9wDyH1vc1Mxhmkccvj_b-To-5JVWA8-qvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] Re: [PATCH v3 -resend] move RLIMIT_NPROC check
 from set_user() to do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 11, 2011 at 10:18 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>
> It got 2 positive feedbacks and seems nobody has better solution.
> Is it possible to see it in 3.1?

Yup. Applied. Thanks for keeping at it,

                      Linus
