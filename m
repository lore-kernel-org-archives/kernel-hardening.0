Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 8 Mar 2016 21:00:13 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20160308210013.15ee166d@lxorguk.ukuu.org.uk>
In-Reply-To: <1457470075-4586-3-git-send-email-sbauer@eng.utah.edu>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
	<1457470075-4586-3-git-send-email-sbauer@eng.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 3/3] SROP mitigation: Add sysctl to disable SROP
 protection.
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, wmealing@redhat.com, ak@linux.intel.com, luto@amacapital.net, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue,  8 Mar 2016 13:47:55 -0700
Scott Bauer <sbauer@eng.utah.edu> wrote:

> This patch adds a sysctl argument to disable SROP protection.

Shouldn't it be a sysctl to enable it irrevocably, otherwise if I have DAC
capability I can turn off SROP and attack something to get to higher
capability levels ?

(The way almost all distros are set up its kind of academic but for a
properly secured system it might matter).

Alan
