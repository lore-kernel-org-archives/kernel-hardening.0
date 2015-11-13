Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 13 Nov 2015 03:08:53 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20151113030853.7b1e669591fc4e08e42c76cd@gmail.com>
In-Reply-To: <564487E2.7090603@redhat.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<20151107223437.891207864301c26862ae15da@gmail.com>
	<5643436F.3060909@redhat.com>
	<56448481.5348.383139DB@pageexec.freemail.hu>
	<564487E2.7090603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, pageexec@freemail.hu, Kees Cook <keescook@chromium.org>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

 
> Do you have any pointers on the overflows that can be introduced by the
> front-end?  I guess I can also look for hints in the plugin source code.

Hi,

You can find most of them in fold-const.c. Here is an example:
https://gcc.gnu.org/ml/gcc-help/2011-10/msg00136.html

-- 
Emese
