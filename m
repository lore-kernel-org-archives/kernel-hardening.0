Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 7 Nov 2015 23:07:02 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20151107230702.e10955217163dee58f989daf@gmail.com>
In-Reply-To: <20151107054217.GA32075@x>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	<20151107002508.GA2605@cloud>
	<20151107024612.GC19551@kroah.com>
	<CAGXu5jK70Rn3QqzkwDRMDmt-sW0Xhw0X8afp3KLgw4SYPiZHrQ@mail.gmail.com>
	<20151107054217.GA32075@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


> I agree in both cases: having the plugin usable in "make it so" mode for
> the benefit of legacy or out-of-tree code, and having it usable in
> "suggest changes to the source" (or outright *edit* the source and
> produce a patch) mode to avoid actually mandating the plugin.  Not least
> of which because I'd find it surprising if the plugin ever worked across
> as broad a range of GCC versions as the kernel typically wants to
> support.

All gcc plugins in PaX support all plugin capable gcc versions (4.5-5). 
This is PaXTeam's requirement if somebody writes a plugin for PaX.
And of course the plugin infrastructure handles gcc versions that don't
support plugins.

-- 
Emese
