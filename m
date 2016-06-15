Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2016 22:39:52 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160615223952.f3a4ece452b15c62babf4629@gmail.com>
In-Reply-To: <CAGXu5jK-QVhbuOnNENq9PesPTdPCnbgODzb0qn=q4ZMS0-ndBA@mail.gmail.com>
References: <20160615001754.f9e986cf961d1466f5e086dc@gmail.com>
	<CAGXu5jK-QVhbuOnNENq9PesPTdPCnbgODzb0qn=q4ZMS0-ndBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 0/4] Introduce the latent_entropy gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 15 Jun 2016 11:55:44 -0700
Kees Cook <keescook@chromium.org> wrote:

>  The limit on the length of lines is 80 columns and this is a strongly
>  preferred limit.

I think the code looks worse when it is truncated to 80 columns but
I'll do it and resend the patches.

-- 
Emese
