Date: Fri, 29 Mar 2019 18:37:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Message-ID: <20190329173723.GB23683@redhat.com>
References: <20190327145331.215360-1-joel@joelfernandes.org>
 <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
 <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
 <20190328023432.GA93275@google.com>
 <20190328142619.GA19441@redhat.com>
 <20190328143958.GB261521@google.com>
 <20190329023456.GB194158@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329023456.GB194158@google.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/28, Joel Fernandes wrote:
>
> Also Oleg, why not just call refcount_dec_and_test like below?

Of course we can, this is just optimization to avoid the atomic op if possible.

Does this optimization really help? I have no idea ;)

But as you can see, it surely helps to provoke the interesting discussions!

Oleg.
