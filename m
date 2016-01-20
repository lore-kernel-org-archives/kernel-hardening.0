Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 20 Jan 2016 10:57:39 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
In-Reply-To: <20160119112812.GA10818@mwanda>
Message-ID: <alpine.LNX.2.00.1601201056290.4459@pobox.suse.cz>
References: <20160119112812.GA10818@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: 2015 kernel CVEs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 19 Jan 2016, Dan Carpenter wrote:

> CVE-2015-3339 : fs: race condition between chown and execve

FWIW, fixed by 8b01fc86b9f4 ("fs: take i_mutex during prepare_binprm for 
set[ug]id executables").

Regards,
Miroslav
