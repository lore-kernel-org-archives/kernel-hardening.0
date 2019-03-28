MIME-Version: 1.0
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
 <20190328023432.GA93275@google.com> <CAG48ez2bbSYpNHcC4oucx_AG=5y4K5pZfSOfN3mxGadJGpHuQQ@mail.gmail.com>
 <20190328143738.GA261521@google.com>
In-Reply-To: <20190328143738.GA261521@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 28 Mar 2019 09:52:09 -0700
Message-ID: <CAGXu5j+CFmdPQd_u6=C6ew0Y-j6ihUN7yN1GpJO6V=x2_Q6kRA@mail.gmail.com>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Content-Type: text/plain; charset="UTF-8"
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 28, 2019 at 7:37 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> Kees can you describe more the race you had in mind?

I just didn't see any barriers, so it seemed racey to me.

> Also note to the on looker, the original patch I sent is not wrong, that
> still applies and is correct. We are just discussing here any possible issues
> with the *existing* code.

Correct. And akpm has (correctly) taken this for -mm.

-- 
Kees Cook
