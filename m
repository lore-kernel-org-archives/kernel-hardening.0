Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 22:20:52 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160119222052.4c093972b55873bd61a416ae@gmail.com>
In-Reply-To: <CAGXu5jL5JV2WS2GVuL16N82DYGVqshveOfWs=iTzH+1XeuSiaA@mail.gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jL5JV2WS2GVuL16N82DYGVqshveOfWs=iTzH+1XeuSiaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "pageexec@freemail.hu" <pageexec@freemail.hu>, "spender@grsecurity.net" <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

 
> Can you give a status update on the constify plugin work? I'm curious
> to hear what your plans are.

Hi,

I'll begin with the gcc plugin infrastructure from February on.
When I'm done with it I'll continue to work on the following plugins
(I'm not sure of the order maybe I can work in parallel on them):
1. initify
2. structleak
3. latent_entropy
4. constify

-- 
Emese
